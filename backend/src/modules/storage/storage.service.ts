import { Injectable, InternalServerErrorException, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3';
import { v4 as uuidv4 } from 'uuid';
import * as path from 'path';

@Injectable()
export class StorageService {
    private readonly logger = new Logger(StorageService.name);
    private s3Client: S3Client;
    private bucketName: string;
    private publicUrl: string;

    constructor(private configService: ConfigService) {
        const accountId = this.configService.get<string>('R2_ACCOUNT_ID')!;
        const accessKeyId = this.configService.get<string>('R2_ACCESS_KEY_ID')!;
        const secretAccessKey = this.configService.get<string>('R2_SECRET_ACCESS_KEY')!;

        this.bucketName = this.configService.get<string>('R2_BUCKET_NAME')!;
        this.publicUrl = this.configService.get<string>('R2_PUBLIC_URL')!;

        this.s3Client = new S3Client({
            region: 'auto',
            endpoint: `https://${accountId}.r2.cloudflarestorage.com`,
            credentials: {
                accessKeyId,
                secretAccessKey,
            },
        });
    }

    async uploadFile(file: Express.Multer.File, folder: string): Promise<string> {
        const fileExtension = path.extname(file.originalname);
        const fileName = `${folder}/${uuidv4()}${fileExtension}`;

        try {
            await this.s3Client.send(
                new PutObjectCommand({
                    Bucket: this.bucketName,
                    Key: fileName,
                    Body: file.buffer,
                    ContentType: file.mimetype,
                }),
            );

            // Return the public URL for the uploaded file
            return `${this.publicUrl}/${fileName}`;
        } catch (error: any) {
            // Logic for Circuit Breaker: Log the exact error but provide a clear user-facing exception
            this.logger.error(`Storage Upload Failed for file ${file.originalname}: ${error.message}`, error.stack);
            throw new InternalServerErrorException('Storage service is currently unavailable. Please try again later.');
        }
    }
}
