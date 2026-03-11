import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { InjectQueue } from '@nestjs/bullmq';
import { Queue } from 'bullmq';
import { v4 as uuidv4 } from 'uuid';
import * as path from 'path';

@Injectable()
export class MediaService {
    private readonly logger = new Logger(MediaService.name);
    private s3Client: S3Client;
    private bucketName: string;

    constructor(
        private configService: ConfigService,
        @InjectQueue('media-uploads') private mediaQueue: Queue,
    ) {
        const accountId = this.configService.get<string>('R2_ACCOUNT_ID')!;
        const accessKeyId = this.configService.get<string>('R2_ACCESS_KEY_ID')!;
        const secretAccessKey = this.configService.get<string>('R2_SECRET_ACCESS_KEY')!;
        this.bucketName = this.configService.get<string>('R2_BUCKET_NAME')!;

        this.s3Client = new S3Client({
            region: 'auto',
            endpoint: `https://${accountId}.r2.cloudflarestorage.com`,
            credentials: {
                accessKeyId,
                secretAccessKey,
            },
        });
    }

    /**
     * Generates a presigned URL for direct upload to R2.
     * This is the "Primary" path for fast, user-facing uploads.
     */
    async generatePresignedUrl(fileName: string, contentType: string) {
        const key = `uploads/${uuidv4()}-${fileName}`;
        const command = new PutObjectCommand({
            Bucket: this.bucketName,
            Key: key,
            ContentType: contentType,
        });

        // Valid for 15 minutes
        const url = await getSignedUrl(this.s3Client, command, { expiresIn: 900 });

        return {
            uploadUrl: url,
            fileUrl: `${this.configService.get('R2_PUBLIC_URL')}/${key}`,
            key,
        };
    }

    /**
     * Adds an image to the background fallback queue.
     * This is the "Safety Net" if direct upload fails.
     */
    async uploadFallback(file: Express.Multer.File, postId?: string) {
        const job = await this.mediaQueue.add(
            'upload-image',
            {
                fileBuffer: file.buffer,
                fileName: file.originalname,
                contentType: file.mimetype,
                postId,
            },
            {
                attempts: 5,
                backoff: {
                    type: 'exponential',
                    delay: 5000, // Start with 5s
                },
            },
        );

        return { jobId: job.id, status: 'queued' };
    }
}
