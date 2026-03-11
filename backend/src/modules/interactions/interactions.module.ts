import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Like } from './entities/like.entity';
import { Comment } from './entities/comment.entity';
import { InteractionsService } from './interactions.service';
import { InteractionsController } from './interactions.controller';
import { Post } from '../posts/entities/post.entity';
import { BullModule } from '@nestjs/bullmq';
import { InteractionsProcessor } from './interactions.processor';

@Module({
    imports: [
        TypeOrmModule.forFeature([Like, Comment, Post]),
        BullModule.registerQueue({
            name: 'interactions',
        }),
    ],
    providers: [InteractionsService, InteractionsProcessor],
    controllers: [InteractionsController],
})
export class InteractionsModule { }
