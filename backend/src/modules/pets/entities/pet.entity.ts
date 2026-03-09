import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    CreateDateColumn,
    UpdateDateColumn,
    ManyToOne,
    Index,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { PetType, PetStatus } from '../enums/pet.enum';
import type { Point } from 'geojson';

@Entity('pets')
export class Pet {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({
        type: 'enum',
        enum: PetType,
        default: PetType.OTHER,
    })
    type: PetType;

    @Column({
        type: 'enum',
        enum: PetStatus,
        default: PetStatus.LOST,
    })
    status: PetStatus;

    @Column('text')
    breed: string;

    @Column('text')
    color: string;

    @Column('text', { nullable: true })
    description: string;

    @Column('simple-array', { nullable: true })
    images: string[];

    @Index({ spatial: true })
    @Column({
        type: 'geography',
        spatialFeatureType: 'Point',
        srid: 4326,
        nullable: true,
    })
    location: any;

    @Column({ type: 'timestamp', nullable: true })
    lastSeenAt: Date;

    @Column({ default: false })
    isResolved: boolean;

    @ManyToOne(() => User, (user: User) => user.id)
    poster: User;

    @CreateDateColumn()
    createdAt: Date;

    @UpdateDateColumn()
    updatedAt: Date;
}
