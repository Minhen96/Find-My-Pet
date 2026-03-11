import { Injectable, NotFoundException, Inject, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Post } from './entities/post.entity';
import { CreatePostDto } from './dto/create-post.dto';
import { UpdatePostDto } from './dto/update-post.dto';
import { FindPostsDto } from './dto/find-posts.dto';
import { StorageService } from '../storage/storage.service';
import { User } from '../users/entities/user.entity';
import Redis from 'ioredis';
import * as crypto from 'crypto';
import { REDIS_KEYS } from '../../common/constants/app.constants';
import { CircuitBreaker } from '../../common/utils/circuit-breaker';

@Injectable()
export class PostsService {
    private readonly redisBreaker: CircuitBreaker;

    constructor(
        @InjectRepository(Post)
        private readonly postsRepository: Repository<Post>,
        private readonly storageService: StorageService,
        @Inject('REDIS_CLIENT')
        private readonly redis: Redis,
    ) {
        this.redisBreaker = new CircuitBreaker('Redis', 5, 30000);
    }

    async create(
        createPostDto: CreatePostDto,
        files: Express.Multer.File[],
        user: User,
    ): Promise<Post> {
        const imageUrls: string[] = createPostDto.imageUrls || [];

        if (files && files.length > 0) {
            for (const file of files) {
                const url = await this.storageService.uploadFile(file, 'posts');
                if (url) {
                    imageUrls.push(url);
                }
            }
        }

        const location = {
            type: 'Point',
            coordinates: [createPostDto.longitude, createPostDto.latitude],
        };

        const { imageUrls: _, petProfileId, ...rest } = createPostDto;

        const post = await this.postsRepository.save(this.postsRepository.create({
            ...rest,
            images: imageUrls,
            location,
            poster: user,
            petProfile: petProfileId ? { id: petProfileId } : undefined,
        }));

        await this.invalidateCache();

        return post;
    }

    async findAll(query?: FindPostsDto): Promise<Post[]> {
        const queryHash = crypto
            .createHash('md5')
            .update(JSON.stringify(query || {}))
            .digest('hex');
        const cacheKey = `${REDIS_KEYS.FEED_CACHE_PREFIX}${queryHash}`;

        const cachedData = await this.redisBreaker.execute(
            () => this.redis.get(cacheKey),
            null,
        );

        if (cachedData) {
            return JSON.parse(cachedData);
        }

        const queryBuilder = this.postsRepository.createQueryBuilder('post')
            .leftJoinAndSelect('post.poster', 'poster')
            .leftJoinAndSelect('post.petProfile', 'petProfile')
            .orderBy('post.createdAt', 'DESC');

        if (query) {
            if (query.type) {
                queryBuilder.andWhere('post.type = :type', { type: query.type });
            }

            if (query.latitude && query.longitude && query.radius) {
                queryBuilder.andWhere(
                    'ST_DWithin(post.location, ST_MakePoint(:longitude, :latitude)::geography, :radius)',
                    {
                        longitude: query.longitude,
                        latitude: query.latitude,
                        radius: query.radius,
                    },
                );
            }

            if (query.cursor) {
                const cursorDate = new Date(query.cursor);
                queryBuilder.andWhere('post.createdAt < :cursor', { cursor: cursorDate });
            }

            if (query.userId) {
                queryBuilder.andWhere('poster.id = :userId', { userId: query.userId });
            }

            if (query.petProfileId) {
                queryBuilder.andWhere('petProfile.id = :petProfileId', { petProfileId: query.petProfileId });
            }

            if (query.limit) {
                queryBuilder.take(query.limit);
            }
        }

        const posts = await queryBuilder.getMany();

        await this.redisBreaker.execute(
            () => this.redis.set(cacheKey, JSON.stringify(posts), 'EX', 300),
            null,
        );

        return posts;
    }

    async findOne(id: string): Promise<Post> {
        const post = await this.postsRepository.findOne({
            where: { id },
            relations: ['poster', 'petProfile'],
        });

        if (!post) {
            throw new NotFoundException(`Post with ID ${id} not found`);
        }

        return post;
    }

    async update(
        id: string,
        userId: string,
        updatePostDto: UpdatePostDto,
        files?: Express.Multer.File[],
    ): Promise<Post> {
        const post = await this.findOne(id);

        if (post.poster.id !== userId) {
            throw new ForbiddenException('You do not have permission to update this post');
        }

        const imageUrls = [
            ...(updatePostDto.imageUrls || post.images || []),
        ];

        if (files && files.length > 0) {
            for (const file of files) {
                const url = await this.storageService.uploadFile(file, 'posts');
                if (url) {
                    imageUrls.push(url);
                }
            }
        }

        const updateData: any = { ...updatePostDto };
        if (updatePostDto.latitude && updatePostDto.longitude) {
            updateData.location = {
                type: 'Point',
                coordinates: [updatePostDto.longitude, updatePostDto.latitude],
            };
            delete updateData.latitude;
            delete updateData.longitude;
        }

        Object.assign(post, { ...updateData, images: imageUrls });
        const updatedPost = await this.postsRepository.save(post);

        await this.invalidateCache();
        return updatedPost;
    }

    async remove(id: string, userId: string): Promise<void> {
        const post = await this.findOne(id);

        if (post.poster.id !== userId) {
            throw new ForbiddenException('You do not have permission to delete this post');
        }

        await this.postsRepository.remove(post);
        await this.invalidateCache();
    }

    private async invalidateCache() {
        await this.redisBreaker.execute(
            async () => {
                const keys = await this.redis.keys(`${REDIS_KEYS.FEED_CACHE_PREFIX}*`);
                if (keys.length > 0) {
                    await this.redis.del(...keys);
                }
            },
            null,
        );
    }
}
