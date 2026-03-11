import { Module } from '@nestjs/common';
import { BullModule } from '@nestjs/bullmq';
import { TypeOrmModule } from '@nestjs/typeorm';
import { MediaService } from './media.service';
import { MediaController } from './media.controller';
import { MediaProcessor } from './media.processor';
import { Post } from '../posts/entities/post.entity';

@Module({
    imports: [
        BullModule.registerQueue({
            name: 'media-uploads',
        }),
        TypeOrmModule.forFeature([Post]),
    ],
    controllers: [MediaController],
    providers: [MediaService, MediaProcessor],
    exports: [MediaService],
})
export class MediaModule { }
