import { Processor, WorkerHost } from '@nestjs/bullmq';
import { Logger, Inject } from '@nestjs/common';
import { Job } from 'bullmq';
import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3';
import { ConfigService } from '@nestjs/config';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Post } from '../posts/entities/post.entity';

@Processor('media-uploads')
export class MediaProcessor extends WorkerHost {
    private readonly logger = new Logger(MediaProcessor.name);
    private s3Client: S3Client;
    private bucketName: string;

    constructor(
        private configService: ConfigService,
        @InjectRepository(Post)
        private postRepository: Repository<Post>,
    ) {
        super();
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

    async process(job: Job<any, any, string>): Promise<any> {
        const { fileBuffer, fileName, contentType, postId } = job.data;

        this.logger.log(`Processing fallback upload for: ${fileName}`);

        try {
            const key = `fallback/${Date.now()}-${fileName}`;

            // 1. Upload to R2
            await this.s3Client.send(
                new PutObjectCommand({
                    Bucket: this.bucketName,
                    Key: key,
                    Body: Buffer.from(fileBuffer),
                    ContentType: contentType,
                }),
            );

            const fileUrl = `${this.configService.get('R2_PUBLIC_URL')}/${key}`;
            this.logger.log(`Successfully uploaded fallback image: ${fileUrl}`);

            // 2. If it was linked to a post, update the post
            if (postId) {
                const post = await this.postRepository.findOne({ where: { id: postId } });
                if (post) {
                    const currentImages = post.images || [];
                    post.images = [...currentImages, fileUrl];
                    await this.postRepository.save(post);
                    this.logger.log(`Linked fallback image to post: ${postId}`);
                }
            }

            return { fileUrl };
        } catch (error) {
            this.logger.error(`Fallback upload failed: ${error.message}`);
            throw error; // BullMQ will retry based on config
        }
    }
}
