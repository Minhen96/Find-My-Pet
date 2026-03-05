import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { JwtStrategy } from './jwt.strategy';
import { UsersModule } from '../users/users.module';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';

import { JwtRefreshStrategy } from './jwt-refresh.strategy';

@Module({
    imports: [
        UsersModule,
        PassportModule.register({ defaultStrategy: 'jwt' }),
        // registerAsync is used to inject ConfigService to get the JWT secret and expiration time
        JwtModule.registerAsync({
            // imports: [ConfigModule] -> import ConfigModule to be able to use it in the useFactory function
            imports: [ConfigModule],
            // inject is used to inject ConfigService into the useFactory function
            inject: [ConfigService],
            // useFactory is used to create the JWT module
            useFactory: async (configService: ConfigService) => ({
                secret: configService.get<string>('JWT_SECRET'),
                signOptions: {
                    expiresIn: configService.get<string>('JWT_EXPIRES_IN') as any,
                },
            }),
        }),
    ],
    controllers: [AuthController],
    // provide JwtStrategy to be used in other modules
    providers: [JwtStrategy, JwtRefreshStrategy, AuthService],
    // export JwtModule and PassportModule to be used in other modules
    exports: [JwtModule, PassportModule],
})
export class AuthModule { }
