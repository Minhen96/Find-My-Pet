import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PetProfile } from './entities/pet-profile.entity';
import { CreatePetProfileDto } from './dto/create-pet-profile.dto';
import { UpdatePetProfileDto } from './dto/update-pet-profile.dto';
import { StorageService } from '../storage/storage.service';
import { User } from '../users/entities/user.entity';

@Injectable()
export class PetsService {
    constructor(
        @InjectRepository(PetProfile)
        private readonly petProfileRepository: Repository<PetProfile>,
        private readonly storageService: StorageService,
    ) { }

    async create(
        createDto: CreatePetProfileDto,
        files: Express.Multer.File[],
        user: User,
    ): Promise<PetProfile> {
        const imageUrls: string[] = createDto.imageUrls || [];

        if (files && files.length > 0) {
            for (const file of files) {
                const url = await this.storageService.uploadFile(file, 'pet-profiles');
                if (url) {
                    imageUrls.push(url);
                }
            }
        }

        const petProfile = this.petProfileRepository.create({
            ...createDto,
            images: imageUrls,
            owner: user,
        });

        return this.petProfileRepository.save(petProfile);
    }

    async findAll(user: User): Promise<PetProfile[]> {
        return this.petProfileRepository.find({
            where: { owner: { id: user.id } },
            order: { createdAt: 'DESC' },
        });
    }

    async findOne(id: string): Promise<PetProfile> {
        const profile = await this.petProfileRepository.findOne({
            where: { id },
            relations: ['owner'],
        });

        if (!profile) {
            throw new NotFoundException(`Pet profile with ID ${id} not found`);
        }

        return profile;
    }

    async update(
        id: string,
        userId: string,
        updateDto: UpdatePetProfileDto,
        files?: Express.Multer.File[],
    ): Promise<PetProfile> {
        const profile = await this.findOne(id);

        if (profile.owner.id !== userId) {
            throw new ForbiddenException('You do not have permission to update this profile');
        }

        const imageUrls = [
            ...(updateDto.imageUrls || profile.images || []),
        ];

        if (files && files.length > 0) {
            for (const file of files) {
                const url = await this.storageService.uploadFile(file, 'pet-profiles');
                if (url) {
                    imageUrls.push(url);
                }
            }
        }

        Object.assign(profile, { ...updateDto, images: imageUrls });
        return this.petProfileRepository.save(profile);
    }

    async remove(id: string, userId: string): Promise<void> {
        const profile = await this.findOne(id);

        if (profile.owner.id !== userId) {
            throw new ForbiddenException('You do not have permission to delete this profile');
        }

        await this.petProfileRepository.remove(profile);
    }
}
