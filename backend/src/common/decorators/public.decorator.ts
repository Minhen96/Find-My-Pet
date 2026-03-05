import { SetMetadata } from '@nestjs/common';

// this decorator is to mark a route as public
export const IS_PUBLIC_KEY = 'isPublic';
export const Public = () => SetMetadata(IS_PUBLIC_KEY, true);
