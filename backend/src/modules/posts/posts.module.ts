import { Module, forwardRef } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Post } from './entities/post.entity';
import { PostsService } from './posts.service';
import { PostsController } from './posts.controller';
import { StorageModule } from '../storage/storage.module';
import { InteractionsModule } from '../interactions/interactions.module';
import { PetsModule } from '../pets/pets.module';

@Module({
    imports: [
        TypeOrmModule.forFeature([Post]),
        StorageModule,
        forwardRef(() => InteractionsModule),
        forwardRef(() => PetsModule),
    ],
    controllers: [PostsController],
    providers: [PostsService],
    exports: [PostsService, TypeOrmModule],
})
export class PostsModule { }
