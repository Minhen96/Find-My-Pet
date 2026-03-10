import { Module } from '@nestjs/common';
import { BullModule } from '@nestjs/bullmq';
import { TypeOrmModule } from '@nestjs/typeorm';
import { MediaService } from './media.service';
import { MediaController } from './media.controller';
import { MediaProcessor } from './media.processor';
import { Pet } from '../pets/entities/pet.entity';

@Module({
    imports: [
        BullModule.registerQueue({
            name: 'media-uploads',
        }),
        TypeOrmModule.forFeature([Pet]),
    ],
    controllers: [MediaController],
    providers: [MediaService, MediaProcessor],
    exports: [MediaService],
})
export class MediaModule { }
