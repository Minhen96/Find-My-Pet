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
import { PetProfile } from '../../pets/entities/pet-profile.entity';
import { PetType, PetStatus } from '../../pets/enums/pet.enum';

@Entity('posts')
export class Post {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({
        type: 'enum',
        enum: PetStatus,
        default: PetStatus.LOST,
    })
    type: PetStatus; // Renaming 'status' to 'type' in conceptually, but keeping the enum for now

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

    @ManyToOne(() => User)
    poster: User;

    @ManyToOne(() => PetProfile, { nullable: true })
    petProfile: PetProfile;

    // Optional: for ad-hoc posts without a profile
    @Column({
        type: 'enum',
        enum: PetType,
        nullable: true,
    })
    animalType: PetType;

    @Column({ nullable: true })
    breed: string;

    @Column({ nullable: true })
    color: string;

    @CreateDateColumn()
    createdAt: Date;

    @UpdateDateColumn()
    updatedAt: Date;
}
