import {
    ExceptionFilter,
    Catch,
    ArgumentsHost,
    HttpException,
    HttpStatus,
    Logger,
} from '@nestjs/common';
import { Request, Response } from 'express';

@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
    private readonly logger = new Logger(GlobalExceptionFilter.name);

    // catch function is called when an exception is thrown
    // exception: unknown -> the exception that was thrown
    // host: ArgumentsHost -> the execution context
    catch(exception: unknown, host: ArgumentsHost) {
        const ctx = host.switchToHttp();
        const response = ctx.getResponse<Response>();
        const request = ctx.getRequest<any>();

        // Determine the status code and message based on the exception type
        const status =
            exception instanceof HttpException
                ? exception.getStatus()
                : HttpStatus.INTERNAL_SERVER_ERROR;

        const message =
            exception instanceof HttpException
                ? exception.getResponse()
                : 'Internal server error';

        const correlationId = request['correlationId'] || 'no-id';

        // Log the error
        this.logger.error(
            `[${correlationId}] ${request.method} ${request.url} ${status} - ${exception instanceof Error ? exception.message : JSON.stringify(message)
            }`,
            exception instanceof Error ? exception.stack : '',
        );

        // Standardized error response
        response.status(status).json({
            statusCode: status,
            timestamp: new Date().toISOString(),
            path: request.url,
            message: message,
            correlationId, // 🆔 Help the user find their error in the logs!
        });
    }
}
