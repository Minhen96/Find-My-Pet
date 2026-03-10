import { Injectable, NotFoundException, Inject, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Pet } from './entities/pet.entity';
import { CreatePetDto } from './dto/create-pet.dto';
import { UpdatePetDto } from './dto/update-pet.dto';
import { FindPetsDto } from './dto/find-pets.dto';
import { StorageService } from '../storage/storage.service';
import { User } from '../users/entities/user.entity';
import Redis from 'ioredis';
import * as crypto from 'crypto';
import { REDIS_KEYS } from '../../common/constants/app.constants';

@Injectable()
export class PetsService {
    constructor(
        @InjectRepository(Pet)
        private readonly petsRepository: Repository<Pet>,
        private readonly storageService: StorageService,
        @Inject('REDIS_CLIENT')
        private readonly redis: Redis,
    ) { }

    async create(
        createPetDto: CreatePetDto,
        files: Express.Multer.File[],
        user: User,
    ): Promise<Pet> {
        const imageUrls: string[] = [];

        if (files && files.length > 0) {
            for (const file of files) {
                const url = await this.storageService.uploadFile(file, 'pets');
                imageUrls.push(url);
            }
        }

        const location = {
            type: 'Point',
            coordinates: [createPetDto.longitude, createPetDto.latitude],
        };

        const pet = await this.petsRepository.save(this.petsRepository.create({
            ...createPetDto,
            images: imageUrls,
            location,
            poster: user,
        }));

        // Invalidate all feed caches on new pet creation
        const keys = await this.redis.keys(`${REDIS_KEYS.FEED_CACHE_PREFIX}*`);
        if (keys.length > 0) {
            await this.redis.del(...keys);
        }

        return pet;
    }

    async findAll(query?: FindPetsDto): Promise<Pet[]> {
        // 1. Create a unique cache key based on the query parameters
        const queryHash = crypto
            .createHash('md5')
            .update(JSON.stringify(query || {}))
            .digest('hex');
        const cacheKey = `${REDIS_KEYS.FEED_CACHE_PREFIX}${queryHash}`;

        // 2. Check Redis Cache
        const cachedData = await this.redis.get(cacheKey);
        if (cachedData) {
            return JSON.parse(cachedData);
        }

        // 3. Cache Miss: Fetch from Database
        const queryBuilder = this.petsRepository.createQueryBuilder('pet')
            .leftJoinAndSelect('pet.poster', 'poster')
            .orderBy('pet.createdAt', 'DESC');

        if (query) {
            if (query.type) {
                queryBuilder.andWhere('pet.type = :type', { type: query.type });
            }

            if (query.status) {
                queryBuilder.andWhere('pet.status = :status', { status: query.status });
            }

            if (query.latitude && query.longitude && query.radius) {
                queryBuilder.andWhere(
                    'ST_DWithin(pet.location, ST_MakePoint(:longitude, :latitude)::geography, :radius)',
                    {
                        longitude: query.longitude,
                        latitude: query.latitude,
                        radius: query.radius,
                    },
                );
            }
        }

        const pets = await queryBuilder.getMany();

        // 4. Save to Redis Cache (TTL: 5 minutes = 300 seconds)
        await this.redis.set(cacheKey, JSON.stringify(pets), 'EX', 300);

        return pets;
    }

    async findOne(id: string): Promise<Pet> {
        const pet = await this.petsRepository.findOne({
            where: { id },
            relations: ['poster'],
        });

        if (!pet) {
            throw new NotFoundException(`Pet with ID ${id} not found`);
        }

        return pet;
    }

    async update(
        id: string,
        userId: string,
        updatePetDto: UpdatePetDto,
        files?: Express.Multer.File[],
    ): Promise<Pet> {
        const pet = await this.findOne(id);

        if (pet.poster.id !== userId) {
            throw new ForbiddenException('You do not have permission to update this post');
        }

        const imageUrls = [...pet.images];
        if (files && files.length > 0) {
            for (const file of files) {
                const url = await this.storageService.uploadFile(file, 'pets');
                imageUrls.push(url);
            }
        }

        const updateData: any = { ...updatePetDto };
        if (updatePetDto.latitude && updatePetDto.longitude) {
            updateData.location = {
                type: 'Point',
                coordinates: [updatePetDto.longitude, updatePetDto.latitude],
            };
            delete updateData.latitude;
            delete updateData.longitude;
        }

        Object.assign(pet, { ...updateData, images: imageUrls });
        const updatedPet = await this.petsRepository.save(pet);

        await this.invalidateCache();
        return updatedPet;
    }

    async remove(id: string, userId: string): Promise<void> {
        const pet = await this.findOne(id);

        if (pet.poster.id !== userId) {
            throw new ForbiddenException('You do not have permission to delete this post');
        }

        await this.petsRepository.remove(pet);
        await this.invalidateCache();
    }

    private async invalidateCache() {
        const keys = await this.redis.keys(`${REDIS_KEYS.FEED_CACHE_PREFIX}*`);
        if (keys.length > 0) {
            await this.redis.del(...keys);
        }
    }
}
