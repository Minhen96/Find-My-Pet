import { ExtractJwt, Strategy } from 'passport-jwt';
import { PassportStrategy } from '@nestjs/passport';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class JwtRefreshStrategy extends PassportStrategy(Strategy, 'jwt-refresh') {
    constructor(private readonly configService: ConfigService) {
        super({
            jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
            ignoreExpiration: false,
            secretOrKey: configService.get<string>('JWT_REFRESH_SECRET')!,
            passReqToCallback: true, // We need to access the request object to extract the raw token
        });
    }

    async validate(req: any, payload: any) {
        if (!payload.sub) {
            throw new UnauthorizedException();
        }

        // Passport extracts the Bearer token for us, but we need the raw string to compare 
        // against the user's database hash. 'authorization' header looks like 'Bearer <token>'
        const refreshToken = req.headers.authorization?.replace('Bearer', '').trim();

        if (!refreshToken) {
            throw new UnauthorizedException('Refresh token malformed');
        }

        return {
            id: payload.sub,
            email: payload.email,
            roles: payload.roles || [],
            refreshToken, // Attach the raw token so the controller/service can hash and verify it
        };
    }
}
