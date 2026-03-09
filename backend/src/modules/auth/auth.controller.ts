import { Controller, Post, Body, Get, HttpCode, HttpStatus, UseGuards } from '@nestjs/common';
import { Throttle } from '@nestjs/throttler';
import { AuthService } from './auth.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { Public } from '../../common/decorators/public.decorator';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { JwtRefreshAuthGuard } from '../../common/guards/jwt-refresh-auth.guard';

@Controller('auth')
export class AuthController {
    constructor(private readonly authService: AuthService) { }

    @Public() // Bypasses the global JwtAuthGuard
    @Throttle({ default: { limit: 5, ttl: 60000 } })
    @Post('register')
    async register(@Body() registerDto: RegisterDto) {
        return this.authService.register(registerDto);
    }

    @Public() // Bypasses the global JwtAuthGuard
    @Throttle({ default: { limit: 5, ttl: 60000 } })
    @Post('login')
    @HttpCode(HttpStatus.OK)
    async login(@Body() loginDto: LoginDto) {
        return this.authService.login(loginDto);
    }

    @Post('logout')
    @HttpCode(HttpStatus.OK)
    async logout(@CurrentUser() user: any) {
        await this.authService.logout(user.id);
        return { message: 'Logged out successfully' };
    }

    @Public() // Bypasses standard JWT guard
    @UseGuards(JwtRefreshAuthGuard) // Mandates the refresh token strategy
    @Post('refresh')
    @HttpCode(HttpStatus.OK)
    async refreshTokens(@CurrentUser() user: any) {
        return this.authService.refreshTokens(user.id, user.refreshToken);
    }

    // This endpoint is globally protected by JwtAuthGuard natively.
    @Get('me')
    getProfile(@CurrentUser() user: any) {
        return user;
    }
}
