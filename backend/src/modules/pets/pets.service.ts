import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Pet } from './entities/pet.entity';
import { CreatePetDto } from './dto/create-pet.dto';
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

    async findAll(): Promise<Pet[]> {
        return this.petsRepository.find({
            relations: ['poster'],
            order: { createdAt: 'DESC' },
        });
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
