import { Injectable, ConflictException, InternalServerErrorException, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { User } from './entities/user.entity';
import { RegisterDto } from '../auth/dto/register.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { Pet } from '../pets/entities/pet.entity';

@Injectable()
export class UsersService {
    constructor(
        @InjectRepository(User)
        private usersRepository: Repository<User>,
        @InjectRepository(Pet)
        private petsRepository: Repository<Pet>,
    ) { }

    async create(registerDto: RegisterDto): Promise<User> {
        const { email, password, displayName, phone } = registerDto;

        // Hash the password securely with a generated salt
        const salt = await bcrypt.genSalt();
        const passwordHash = await bcrypt.hash(password, salt);

        const user = this.usersRepository.create({
            email,
            phone,
            passwordHash,
            displayName,
        });

        try {
            // The TypeORM save command actually triggers the SQL INSERT
            return await this.usersRepository.save(user);
        } catch (error: any) {
            if (error.code === '23505') {
                // 23505 is the PostgreSQL Unique Violation error code
                throw new ConflictException('A user with this email or phone already exists');
            }
            throw new InternalServerErrorException('Failed to create user');
        }
    }

    async findOneByEmail(email: string): Promise<User | null> {
        return this.usersRepository.findOne({ where: { email } });
    }

    async findOneById(id: string): Promise<User | null> {
        return this.usersRepository.findOne({ where: { id } });
    }

    async update(userId: string, updateUserDto: UpdateUserDto): Promise<User> {
        const user = await this.findOneById(userId);
        if (!user) throw new NotFoundException('User not found');

        Object.assign(user, updateUserDto);
        return this.usersRepository.save(user);
    }

    async getUserPets(userId: string): Promise<Pet[]> {
        return this.petsRepository.find({
            where: { poster: { id: userId } },
            order: { createdAt: 'DESC' },
        });
    }

    async updateRefreshToken(userId: string, refreshToken: string): Promise<void> {
        const salt = await bcrypt.genSalt();
        const hashedRefreshToken = await bcrypt.hash(refreshToken, salt);
        await this.usersRepository.update(userId, {
            hashedRefreshToken,
        });
    }

    async removeRefreshToken(userId: string): Promise<void> {
        await this.usersRepository.update(userId, {
            hashedRefreshToken: null as any,
        });
    }
}
