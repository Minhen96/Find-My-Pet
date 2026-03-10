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
} from '@nestjs/common';
import { FilesInterceptor } from '@nestjs/platform-express';
import { Throttle } from '@nestjs/throttler';
import { PetsService } from './pets.service';
import { CreatePetDto } from './dto/create-pet.dto';
import { UpdatePetDto } from './dto/update-pet.dto';
import { FindPetsDto } from './dto/find-pets.dto';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { User } from '../users/entities/user.entity';

@Controller('pets')
export class PetsController {
    constructor(private readonly petsService: PetsService) { }

    @Post()
    @Throttle({ upload: { limit: 10, ttl: 3600000 } })
    @UseInterceptors(FilesInterceptor('images', 5))
    async create(
        @Body() createPetDto: CreatePetDto,
        @UploadedFiles() files: Express.Multer.File[],
        @CurrentUser() user: User,
    ) {
        return this.petsService.create(createPetDto, files, user);
    }

    @Get()
    async findAll(@Query() findPetsDto: FindPetsDto) {
        return this.petsService.findAll(findPetsDto);
    }

    @Get(':id')
    async findOne(@Param('id', ParseUUIDPipe) id: string) {
        return this.petsService.findOne(id);
    }

    @Patch(':id')
    @Throttle({ upload: { limit: 10, ttl: 3600000 } })
    @UseInterceptors(FilesInterceptor('images', 5))
    async update(
        @Param('id', ParseUUIDPipe) id: string,
        @Body() updatePetDto: UpdatePetDto,
        @UploadedFiles() files: Express.Multer.File[],
        @CurrentUser() user: User,
    ) {
        return this.petsService.update(id, user.id, updatePetDto, files);
    }

    @Delete(':id')
    async remove(
        @Param('id', ParseUUIDPipe) id: string,
        @CurrentUser() user: User,
    ) {
        await this.petsService.remove(id, user.id);
        return { message: 'Post deleted successfully' };
    }
}
