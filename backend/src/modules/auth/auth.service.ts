import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { UsersService } from '../users/users.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';

@Injectable()
export class AuthService {
    constructor(
        private usersService: UsersService,
        private jwtService: JwtService,
    ) { }

    async register(registerDto: RegisterDto) {
        // 1. Create the user in the database (UsersService handles hashing & saving)
        const user = await this.usersService.create(registerDto);

        // 2. Automatically log them in by generating a JWT
        const payload = { sub: user.id, email: user.email, roles: user.roles };
        const accessToken = await this.jwtService.signAsync(payload);

        return {
            user,
            accessToken,
        };
    }

    async login(loginDto: LoginDto) {
        // 1. Find user by email
        const user = await this.usersService.findOneByEmail(loginDto.email);
        if (!user) {
            throw new UnauthorizedException('Invalid credentials');
        }

        // 2. Compare the raw password against the hashed password
        const isPasswordValid = await bcrypt.compare(loginDto.password, user.passwordHash);
        if (!isPasswordValid) {
            throw new UnauthorizedException('Invalid credentials');
        }

        // 3. Generate a JWT token
        const payload = { sub: user.id, email: user.email, roles: user.roles };
        const accessToken = await this.jwtService.signAsync(payload);

        return {
            user,
            accessToken,
        };
    }
}
