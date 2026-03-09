import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PetsService } from './pets.service';
import { PetsController } from './pets.controller';
import { Pet } from './entities/pet.entity';
import { StorageModule } from '../storage/storage.module';

@Module({
    imports: [TypeOrmModule.forFeature([Pet]), StorageModule],
    controllers: [PetsController],
    providers: [PetsService],
    exports: [PetsService],
})
export class PetsModule { }
