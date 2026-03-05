import { Injectable, UnauthorizedException, ForbiddenException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import * as bcrypt from 'bcrypt';
import { UsersService } from '../users/users.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';

@Injectable()
export class AuthService {
    constructor(
        private usersService: UsersService,
        private jwtService: JwtService,
        private configService: ConfigService,
    ) { }

    async register(registerDto: RegisterDto) {
        const user = await this.usersService.create(registerDto);
        const tokens = await this.getTokens(user.id, user.email, user.roles);
        await this.updateRefreshTokenHash(user.id, tokens.refreshToken);
        return { user, ...tokens };
    }

    async login(loginDto: LoginDto) {
        const user = await this.usersService.findOneByEmail(loginDto.email);
        if (!user) throw new UnauthorizedException('Invalid credentials');

        const isPasswordValid = await bcrypt.compare(loginDto.password, user.passwordHash);
        if (!isPasswordValid) throw new UnauthorizedException('Invalid credentials');

        const tokens = await this.getTokens(user.id, user.email, user.roles);
        await this.updateRefreshTokenHash(user.id, tokens.refreshToken);
        return { user, ...tokens };
    }

    async logout(userId: string) {
        await this.usersService.removeRefreshToken(userId);
    }

    async refreshTokens(userId: string, refreshToken: string) {
        const user = await this.usersService.findOneById(userId);
        if (!user || !user.hashedRefreshToken) throw new ForbiddenException('Access Denied');

        const refreshTokenMatches = await bcrypt.compare(refreshToken, user.hashedRefreshToken);
        if (!refreshTokenMatches) throw new ForbiddenException('Access Denied');

        const tokens = await this.getTokens(user.id, user.email, user.roles);
        await this.updateRefreshTokenHash(user.id, tokens.refreshToken);
        return tokens;
    }

    private async updateRefreshTokenHash(userId: string, refreshToken: string) {
        await this.usersService.updateRefreshToken(userId, refreshToken);
    }

    private async getTokens(userId: string, email: string, roles: string[]) {
        const payload = { sub: userId, email, roles };
        const [accessToken, refreshToken] = await Promise.all([
            this.jwtService.signAsync(payload),
            this.jwtService.signAsync(payload, {
                secret: this.configService.get<string>('JWT_REFRESH_SECRET'),
                expiresIn: this.configService.get<string>('JWT_REFRESH_EXPIRES_IN') as any,
            }),
        ]);
        return { accessToken, refreshToken };
    }
}
