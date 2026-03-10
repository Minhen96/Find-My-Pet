import { Injectable, NotFoundException, Inject } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import Redis from 'ioredis';
import { InjectQueue } from '@nestjs/bullmq';
import { Queue } from 'bullmq';
import { Like } from './entities/like.entity';
import { Comment } from './entities/comment.entity';
import { User } from '../users/entities/user.entity';
import { Pet } from '../pets/entities/pet.entity';
import { EventsGateway } from '../events/events.gateway';
import { REDIS_KEYS, QUEUE_NAMES, WS_EVENTS, JOB_NAMES } from '../../common/constants/app.constants';

@Injectable()
export class InteractionsService {
    constructor(
        @InjectRepository(Like)
        private likesRepository: Repository<Like>,
        @InjectRepository(Comment)
        private commentsRepository: Repository<Comment>,
        @InjectRepository(Pet)
        private petsRepository: Repository<Pet>,
        @Inject('REDIS_CLIENT')
        private readonly redis: Redis,
        @InjectQueue(QUEUE_NAMES.INTERACTIONS)
        private interactionsQueue: Queue,
        private readonly eventsGateway: EventsGateway,
    ) { }

    async toggleLike(petId: string, user: User) {
        const pet = await this.petsRepository.findOne({ where: { id: petId } });
        if (!pet) throw new NotFoundException('Pet not found');

        const redisKey = REDIS_KEYS.PET_LIKERS(petId);
        const countKey = REDIS_KEYS.PET_LIKES_COUNT(petId);

        // Modern way: Update Cache first
        const isLiked = await this.redis.sismember(redisKey, user.id);

        if (isLiked) {
            // Remove from cache
            await this.redis.srem(redisKey, user.id);
            await this.redis.decr(countKey);

            // 🔥 Add a job to BullMQ - Don't wait for DB!
            // returns "Success" to the user while the DB update happens later
            await this.interactionsQueue.add(JOB_NAMES.UNLIKE, {
                petId,
                userId: user.id,
                action: JOB_NAMES.UNLIKE
            });

            // Broadcast real-time change instantly!
            this.eventsGateway.broadcastToPet(petId, WS_EVENTS.LIKE_UPDATE, {
                liked: false,
                userId: user.id,
                newCount: parseInt(await this.redis.get(countKey) || '0')
            });

            return { liked: false };
        } else {
            // Add to cache
            await this.redis.sadd(redisKey, user.id);
            await this.redis.incr(countKey);

            // 🔥 Add a job to BullMQ - Don't wait for DB!
            // returns "Success" to the user while the DB update happens later
            await this.interactionsQueue.add(JOB_NAMES.LIKE, {
                petId,
                userId: user.id,
                action: JOB_NAMES.LIKE
            });

            // Broadcast real-time change instantly!
            this.eventsGateway.broadcastToPet(petId, WS_EVENTS.LIKE_UPDATE, {
                liked: true,
                userId: user.id,
                newCount: parseInt(await this.redis.get(countKey) || '0')
            });

            return { liked: true };
        }
    }

    async addComment(petId: string, content: string, user: User) {
        const pet = await this.petsRepository.findOne({ where: { id: petId } });
        if (!pet) throw new NotFoundException('Pet not found');

        const comment = this.commentsRepository.create({
            pet,
            user,
            content,
        });

        const savedComment = await this.commentsRepository.save(comment);

        // Broadcast to real-time clients
        this.eventsGateway.broadcastToPet(petId, WS_EVENTS.NEW_COMMENT, savedComment);

        return savedComment;
    }

    async getInteractions(petId: string) {
        const countKey = REDIS_KEYS.PET_LIKES_COUNT(petId);

        // Modern Way: Check cache first
        let likesCount = await this.redis.get(countKey);

        if (likesCount === null) {
            // Cache Miss: Warm it from DB
            likesCount = (await this.likesRepository.count({
                where: { pet: { id: petId } },
            })).toString();
            await this.redis.set(countKey, likesCount, 'EX', 3600); // Cache for 1 hour
        }

        const comments = await this.commentsRepository.find({
            where: { pet: { id: petId } },
            relations: ['user'],
            order: { createdAt: 'DESC' },
        });

        return { likesCount: parseInt(likesCount), comments };
    }
}
