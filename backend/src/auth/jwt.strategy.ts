import { ExtractJwt, Strategy } from 'passport-jwt';
import { PassportStrategy } from '@nestjs/passport';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
    constructor(private readonly configService: ConfigService) {
        super({
            jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
            ignoreExpiration: false,
            secretOrKey: configService.get<string>('JWT_SECRET')!,
        });
    }

    // The validate method is called only if the JWT signature is valid
    // and the token is not expired.
    async validate(payload: any) {
        // The payload is what we encoded in the token (e.g. { sub: userId, email, roles[] })
        // Return the user object, which Passport injects into the request object (req.user)
        if (!payload.sub) {
            throw new UnauthorizedException();
        }

        return {
            id: payload.sub,
            email: payload.email,
            roles: payload.roles || []
        };
    }
}
