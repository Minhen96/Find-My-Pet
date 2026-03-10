import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Pet } from './entities/pet.entity';
import { CreatePetDto } from './dto/create-pet.dto';
import { FindPetsDto } from './dto/find-pets.dto';
import { StorageService } from '../storage/storage.service';
import { User } from '../users/entities/user.entity';
import type { Point } from 'geojson';

@Injectable()
export class PetsService {
    constructor(
        @InjectRepository(Pet)
        private readonly petsRepository: Repository<Pet>,
        private readonly storageService: StorageService,
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

        const location: Point = {
            type: 'Point',
            coordinates: [createPetDto.longitude, createPetDto.latitude],
        };

        const pet = this.petsRepository.create({
            ...createPetDto,
            images: imageUrls,
            location,
            poster: user,
        });

        return this.petsRepository.save(pet);
    }

    async findAll(query?: FindPetsDto): Promise<Pet[]> {
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
                // PostGIS radial search
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

        return queryBuilder.getMany();
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
}
