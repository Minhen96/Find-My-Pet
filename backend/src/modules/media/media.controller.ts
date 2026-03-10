import {
    Controller,
    Post,
    Get,
    Query,
    UseInterceptors,
    UploadedFile,
    Body,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { MediaService } from './media.service';
import { Public } from '../../common/decorators/public.decorator';

@Controller('media')
export class MediaController {
    constructor(private readonly mediaService: MediaService) { }

    @Public() // Allow pre-auth during registration if needed, or secure as needed
    @Get('presigned-url')
    async getPresignedUrl(
        @Query('fileName') fileName: string,
        @Query('contentType') contentType: string,
    ) {
        return this.mediaService.generatePresignedUrl(fileName, contentType);
    }

    @Post('upload-fallback')
    @UseInterceptors(FileInterceptor('file'))
    async uploadFallback(
        @UploadedFile() file: Express.Multer.File,
        @Body('petId') petId?: string,
    ) {
        return this.mediaService.uploadFallback(file, petId);
    }
}
