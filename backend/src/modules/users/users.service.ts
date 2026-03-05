import { Injectable, ConflictException, InternalServerErrorException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { User } from './entities/user.entity';
import { RegisterDto } from '../auth/dto/register.dto';

@Injectable()
export class UsersService {
    constructor(
        @InjectRepository(User)
        private usersRepository: Repository<User>,
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
}
