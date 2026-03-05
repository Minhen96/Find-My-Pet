import { Injectable, NestMiddleware, Logger } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';

@Injectable()
export class LoggerMiddleware implements NestMiddleware {
    private logger = new Logger('HTTP');

    // request: Request -> incoming request
    // response: Response -> outgoing response
    // next: NextFunction -> next middleware in the chain
    use(request: Request, response: Response, next: NextFunction): void {
        const { ip, method, originalUrl } = request;
        const userAgent = request.get('user-agent') || '';

        // Wait for the response to finish, then log the status code
        response.on('finish', () => {
            const { statusCode } = response;
            const contentLength = response.get('content-length') || '0';

            this.logger.log(
                `${method} ${originalUrl} ${statusCode} ${contentLength} - ${userAgent} ${ip}`
            );
        });

        next();
    }
}
