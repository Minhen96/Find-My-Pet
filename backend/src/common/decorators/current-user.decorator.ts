import { createParamDecorator, ExecutionContext } from '@nestjs/common';

// Create a custom decorator to get the user from the request
export const CurrentUser = createParamDecorator(
    // data: unknown -> data passed to the decorator
    // ctx: ExecutionContext -> execution context
    (data: unknown, ctx: ExecutionContext) => {
        const request = ctx.switchToHttp().getRequest();
        // This will grab the user object attached by the JwtAuthGuard
        return request.user;
    },
);
