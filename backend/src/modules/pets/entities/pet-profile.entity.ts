import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    CreateDateColumn,
    UpdateDateColumn,
    ManyToOne,
    OneToMany,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { PetType } from '../enums/pet.enum';

@Entity('pet_profiles')
export class PetProfile {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column()
    name: string;

    @Column({
        type: 'enum',
        enum: PetType,
        default: PetType.OTHER,
    })
    type: PetType;

    @Column('text')
    breed: string;

    @Column({ nullable: true })
    age: number;

    @Column({ nullable: true })
    gender: string;

    @Column('text')
    color: string;

    @Column('text', { nullable: true })
    markings: string;

    @Column('text', { nullable: true })
    healthNotes: string;

    @Column({ nullable: true })
    microchipId: string;

    @Column('simple-array', { nullable: true })
    images: string[];

    @ManyToOne(() => User)
    owner: User;

    @CreateDateColumn()
    createdAt: Date;

    @UpdateDateColumn()
    updatedAt: Date;
}
