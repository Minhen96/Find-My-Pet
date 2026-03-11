import {
    Controller,
    Post,
    Get,
    Body,
    Param,
    UseInterceptors,
    UploadedFiles,
    ParseUUIDPipe,
    Query,
    Patch,
    Delete,
    UseGuards,
} from '@nestjs/common';
import { FilesInterceptor } from '@nestjs/platform-express';
import { Throttle } from '@nestjs/throttler';
import { PostsService } from './posts.service';
import { CreatePostDto } from './dto/create-post.dto';
import { UpdatePostDto } from './dto/update-post.dto';
import { FindPostsDto } from './dto/find-posts.dto';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { User } from '../users/entities/user.entity';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';

@UseGuards(JwtAuthGuard)
@Controller('posts')
export class PostsController {
    constructor(private readonly postsService: PostsService) { }

    @Post()
    @Throttle({ upload: { limit: 10, ttl: 3600000 } })
    @UseInterceptors(FilesInterceptor('images', 5))
    async create(
        @Body() createPostDto: CreatePostDto,
        @UploadedFiles() files: Express.Multer.File[],
        @CurrentUser() user: User,
    ) {
        return this.postsService.create(createPostDto, files, user);
    }

    @Get()
    async findAll(@Query() findPostsDto: FindPostsDto) {
        return this.postsService.findAll(findPostsDto);
    }

    @Get(':id')
    async findOne(@Param('id', ParseUUIDPipe) id: string) {
        return this.postsService.findOne(id);
    }

    @Patch(':id')
    @Throttle({ upload: { limit: 10, ttl: 3600000 } })
    @UseInterceptors(FilesInterceptor('images', 5))
    async update(
        @Param('id', ParseUUIDPipe) id: string,
        @Body() updatePostDto: UpdatePostDto,
        @UploadedFiles() files: Express.Multer.File[],
        @CurrentUser() user: User,
    ) {
        return this.postsService.update(id, user.id, updatePostDto, files);
    }

    @Delete(':id')
    async remove(
        @Param('id', ParseUUIDPipe) id: string,
        @CurrentUser() user: User,
    ) {
        await this.postsService.remove(id, user.id);
        return { message: 'Post deleted successfully' };
    }
}
