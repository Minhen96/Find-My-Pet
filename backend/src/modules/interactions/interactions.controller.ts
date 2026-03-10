import { Controller, Post, Get, Body, Param, UseGuards } from '@nestjs/common';
import { InteractionsService } from './interactions.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { User } from '../users/entities/user.entity';

@Controller('pets/:petId/interactions')
export class InteractionsController {
    constructor(private readonly interactionsService: InteractionsService) { }

    @Post('like')
    @UseGuards(JwtAuthGuard)
    toggleLike(@Param('petId') petId: string, @CurrentUser() user: User) {
        return this.interactionsService.toggleLike(petId, user);
    }

    @Post('comment')
    @UseGuards(JwtAuthGuard)
    addComment(
        @Param('petId') petId: string,
        @Body('content') content: string,
        @CurrentUser() user: User,
    ) {
        return this.interactionsService.addComment(petId, content, user);
    }

    @Get()
    getInteractions(@Param('petId') petId: string) {
        return this.interactionsService.getInteractions(petId);
    }
}
