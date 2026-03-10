import { IsString, IsOptional, MaxLength, IsUrl } from 'class-validator';

export class UpdateUserDto {
    @IsOptional()
    @IsString()
    @MaxLength(50)
    displayName?: string;

    @IsOptional()
    @IsString()
    @MaxLength(500)
    bio?: string;

    @IsOptional()
    @IsUrl()
    avatarUrl?: string;
}
