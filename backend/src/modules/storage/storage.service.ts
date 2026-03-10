import { Injectable, InternalServerErrorException, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3';
import { v4 as uuidv4 } from 'uuid';
import * as path from 'path';
import { CircuitBreaker } from '../../common/utils/circuit-breaker';

@Injectable()
export class StorageService {
    private readonly logger = new Logger(StorageService.name);
    private readonly breaker: CircuitBreaker;
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

        this.breaker = new CircuitBreaker('R2', 3, 60000); // 3 failures, 1 minute reset
    }

    async uploadFile(file: Express.Multer.File, folder: string): Promise<string> {
        const fileExtension = path.extname(file.originalname);
        const fileName = `${folder}/${uuidv4()}${fileExtension}`;

        const action = async () => {
            await this.s3Client.send(
                new PutObjectCommand({
                    Bucket: this.bucketName,
                    Key: fileName,
                    Body: file.buffer,
                    ContentType: file.mimetype,
                }),
            );
            return `${this.publicUrl}/${fileName}`;
        };

        return this.breaker.execute(action, ''); // Return empty string on failure
    }
}
