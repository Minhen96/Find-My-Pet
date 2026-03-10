import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Like } from './entities/like.entity';
import { Comment } from './entities/comment.entity';
import { InteractionsService } from './interactions.service';
import { InteractionsController } from './interactions.controller';
import { Pet } from '../pets/entities/pet.entity';
import { BullModule } from '@nestjs/bullmq';
import { InteractionsProcessor } from './interactions.processor';

@Module({
    imports: [
        TypeOrmModule.forFeature([Like, Comment, Pet]),
        BullModule.registerQueue({
            name: 'interactions',
        }),
    ],
    providers: [InteractionsService, InteractionsProcessor],
    controllers: [InteractionsController],
})
export class InteractionsModule { }
