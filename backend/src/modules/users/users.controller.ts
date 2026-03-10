import { Controller, Get, Patch, Body, UseGuards } from '@nestjs/common';
import { UsersService } from './users.service';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { UpdateUserDto } from './dto/update-user.dto';

@Controller('users')
export class UsersController {
    constructor(private readonly usersService: UsersService) { }

    @Get('me')
    async getMe(@CurrentUser() user: any) {
        // Return full user object from DB (Auth only returns JWT payload)
        return this.usersService.findOneById(user.id);
    }

    @Patch('me')
    async updateMe(
        @CurrentUser() user: any,
        @Body() updateUserDto: UpdateUserDto,
    ) {
        return this.usersService.update(user.id, updateUserDto);
    }

    @Get('me/pets')
    async getMyPets(@CurrentUser() user: any) {
        return this.usersService.getUserPets(user.id);
    }
}
