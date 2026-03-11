import { Processor, WorkerHost } from '@nestjs/bullmq';
import { Job } from 'bullmq';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Like } from './entities/like.entity';
import { Post } from '../posts/entities/post.entity';
import { User } from '../users/entities/user.entity';
import { EventsGateway } from '../events/events.gateway';
import { QUEUE_NAMES, JOB_NAMES } from '../../common/constants/app.constants';

@Processor(QUEUE_NAMES.INTERACTIONS)
export class InteractionsProcessor extends WorkerHost {
    constructor(
        @InjectRepository(Like)
        private likesRepository: Repository<Like>,
        @InjectRepository(Post)
        private postsRepository: Repository<Post>,
        private readonly eventsGateway: EventsGateway,
    ) {
        super();
    }

    async process(job: Job<any, any, string>): Promise<any> {
        const { postId, userId, action } = job.data;

        const post = await this.postsRepository.findOne({ where: { id: postId } });
        if (!post) return;

        if (action === JOB_NAMES.LIKE) {
            const like = this.likesRepository.create({
                post,
                user: { id: userId } as User,
            });
            await this.likesRepository.save(like);
        } else if (action === JOB_NAMES.UNLIKE) {
            await this.likesRepository.delete({
                post: { id: postId },
                user: { id: userId },
            });
        }
    }
}
