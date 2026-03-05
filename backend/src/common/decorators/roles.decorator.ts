import { SetMetadata } from '@nestjs/common';
import { Role } from '../enums/role.enum';

// Set the key for the metadata
export const ROLES_KEY = 'roles';
// Set the metadata for the roles
export const Roles = (...roles: Role[]) => SetMetadata(ROLES_KEY, roles);
