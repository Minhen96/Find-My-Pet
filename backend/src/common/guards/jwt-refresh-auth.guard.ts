import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class JwtRefreshAuthGuard extends AuthGuard('jwt-refresh') {
    // This guard simply ties our route to the named 'jwt-refresh' passport strategy
    // We do not need to check for @Public routes here because the /refresh endpoint is explicitly protected.
}
