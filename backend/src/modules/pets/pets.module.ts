import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PetsService } from './pets.service';
import { PetsController } from './pets.controller';
import { PetProfile } from './entities/pet-profile.entity';
import { StorageModule } from '../storage/storage.module';

@Module({
    imports: [
        TypeOrmModule.forFeature([PetProfile]),
        StorageModule,
    ],
    controllers: [PetsController],
    providers: [PetsService],
    exports: [PetsService, TypeOrmModule],
})
export class PetsModule { }
