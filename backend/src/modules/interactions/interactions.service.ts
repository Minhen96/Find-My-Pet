import { Injectable, NotFoundException, Inject } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import Redis from 'ioredis';
import { InjectQueue } from '@nestjs/bullmq';
import { Queue } from 'bullmq';
import { Like } from './entities/like.entity';
import { Comment } from './entities/comment.entity';
import { User } from '../users/entities/user.entity';
import { Post } from '../posts/entities/post.entity';
import { EventsGateway } from '../events/events.gateway';
import { REDIS_KEYS, QUEUE_NAMES, WS_EVENTS, JOB_NAMES } from '../../common/constants/app.constants';

@Injectable()
export class InteractionsService {
    constructor(
        @InjectRepository(Like)
        private likesRepository: Repository<Like>,
        @InjectRepository(Comment)
        private commentsRepository: Repository<Comment>,
        @InjectRepository(Post)
        private postsRepository: Repository<Post>,
        @Inject('REDIS_CLIENT')
        private readonly redis: Redis,
        @InjectQueue(QUEUE_NAMES.INTERACTIONS)
        private interactionsQueue: Queue,
        private readonly eventsGateway: EventsGateway,
    ) { }

    async toggleLike(postId: string, user: User) {
        const post = await this.postsRepository.findOne({ where: { id: postId } });
        if (!post) throw new NotFoundException('Post not found');

        const redisKey = REDIS_KEYS.POST_LIKERS(postId);
        const countKey = REDIS_KEYS.POST_LIKES_COUNT(postId);

        const isLiked = await this.redis.sismember(redisKey, user.id);

        if (isLiked) {
            await this.redis.srem(redisKey, user.id);
            await this.redis.decr(countKey);

            await this.interactionsQueue.add(JOB_NAMES.UNLIKE, {
                postId,
                userId: user.id,
                action: JOB_NAMES.UNLIKE
            });

            this.eventsGateway.broadcastToPost(postId, WS_EVENTS.LIKE_UPDATE, {
                liked: false,
                userId: user.id,
                newCount: parseInt(await this.redis.get(countKey) || '0')
            });

            return { liked: false };
        } else {
            await this.redis.sadd(redisKey, user.id);
            await this.redis.incr(countKey);

            await this.interactionsQueue.add(JOB_NAMES.LIKE, {
                postId,
                userId: user.id,
                action: JOB_NAMES.LIKE
            });

            this.eventsGateway.broadcastToPost(postId, WS_EVENTS.LIKE_UPDATE, {
                liked: true,
                userId: user.id,
                newCount: parseInt(await this.redis.get(countKey) || '0')
            });

            return { liked: true };
        }
    }

    async addComment(postId: string, content: string, user: User) {
        const post = await this.postsRepository.findOne({ where: { id: postId } });
        if (!post) throw new NotFoundException('Post not found');

        const comment = this.commentsRepository.create({
            post,
            user,
            content,
        });

        const savedComment = await this.commentsRepository.save(comment);

        this.eventsGateway.broadcastToPost(postId, WS_EVENTS.NEW_COMMENT, savedComment);

        return savedComment;
    }

    async getInteractions(postId: string) {
        const countKey = REDIS_KEYS.POST_LIKES_COUNT(postId);

        let likesCount = await this.redis.get(countKey);

        if (likesCount === null) {
            likesCount = (await this.likesRepository.count({
                where: { post: { id: postId } },
            })).toString();
            await this.redis.set(countKey, likesCount, 'EX', 3600);
        }

        const comments = await this.commentsRepository.find({
            where: { post: { id: postId } },
            relations: ['user'],
            order: { createdAt: 'DESC' },
        });

        return { likesCount: parseInt(likesCount), comments };
    }
}
