import {
    Controller,
    Post,
    Get,
    Body,
    Param,
    UseInterceptors,
    UploadedFiles,
    ParseUUIDPipe,
} from '@nestjs/common';
import { FilesInterceptor } from '@nestjs/platform-express';
import { PetsService } from './pets.service';
import { CreatePetDto } from './dto/create-pet.dto';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { User } from '../users/entities/user.entity';

@Controller('pets')
export class PetsController {
    constructor(private readonly petsService: PetsService) { }

    @Post()
    @UseInterceptors(FilesInterceptor('images', 5))
    async create(
        @Body() createPetDto: CreatePetDto,
        @UploadedFiles() files: Express.Multer.File[],
        @CurrentUser() user: User,
    ) {
        return this.petsService.create(createPetDto, files, user);
    }

    @Get()
    async findAll() {
        return this.petsService.findAll();
    }

    @Get(':id')
    async findOne(@Param('id', ParseUUIDPipe) id: string) {
        return this.petsService.findOne(id);
    }
}
