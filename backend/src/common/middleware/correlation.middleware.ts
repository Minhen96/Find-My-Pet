import { Injectable, NestMiddleware } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class CorrelationMiddleware implements NestMiddleware {
    use(req: any, res: Response, next: NextFunction) {
        const correlationId = req.header('x-correlation-id') || uuidv4();

        // Put the ID in the request object so it can be accessed by guards/filters/interceptors
        req['correlationId'] = correlationId;

        // Return it in the response header for the client/mobile app
        res.setHeader('x-correlation-id', correlationId);

        next();
    }
}
