import { Processor, WorkerHost } from '@nestjs/bullmq';
import { Job } from 'bullmq';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Like } from './entities/like.entity';
import { Pet } from '../pets/entities/pet.entity';
import { User } from '../users/entities/user.entity';
import { EventsGateway } from '../events/events.gateway';
import { QUEUE_NAMES, JOB_NAMES } from '../../common/constants/app.constants';

@Processor(QUEUE_NAMES.INTERACTIONS)
export class InteractionsProcessor extends WorkerHost {
    constructor(
        @InjectRepository(Like)
        private likesRepository: Repository<Like>,
        @InjectRepository(Pet)
        private petsRepository: Repository<Pet>,
        private readonly eventsGateway: EventsGateway,
    ) {
        super();
    }

    async process(job: Job<any, any, string>): Promise<any> {
        const { petId, userId, action } = job.data;

        const pet = await this.petsRepository.findOne({ where: { id: petId } });
        if (!pet) return;

        if (action === JOB_NAMES.LIKE) {
            const like = this.likesRepository.create({
                pet,
                user: { id: userId } as User,
            });
            await this.likesRepository.save(like);
        } else if (action === JOB_NAMES.UNLIKE) {
            await this.likesRepository.delete({
                pet: { id: petId },
                user: { id: userId },
            });
        }
    }
}
