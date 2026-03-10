import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    CreateDateColumn,
    UpdateDateColumn,
} from 'typeorm';
import { Exclude } from 'class-transformer';
import { Role } from '../../../common/enums/role.enum';

@Entity('users')
export class User {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({ unique: true, nullable: true })
    email: string;

    @Column({ unique: true, nullable: true })
    phone: string;

    @Column({ nullable: true })
    @Exclude() // Automatically stripped from JSON responses by ClassSerializerInterceptor
    passwordHash: string;

    @Column({ nullable: true })
    @Exclude()
    hashedRefreshToken: string;

    @Column({ unique: true, nullable: true })
    firebaseUid: string;

    @Column()
    displayName: string;

    @Column({ nullable: true })
    avatarUrl: string;

    @Column({ nullable: true, type: 'text' })
    bio: string;

    @Column({
        type: 'enum',
        enum: Role,
        array: true,
        default: [Role.USER],
    })
    roles: Role[];

    @Column({ default: false })
    isVerified: boolean;

    @CreateDateColumn()
    createdAt: Date;

    @UpdateDateColumn()
    updatedAt: Date;
}
