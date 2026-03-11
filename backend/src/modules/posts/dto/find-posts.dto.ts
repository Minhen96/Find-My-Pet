import { IsOptional, IsEnum, IsNumber, IsString, IsUUID } from 'class-validator';
import { Type } from 'class-transformer';
import { PetStatus, PetType } from '../../pets/enums/pet.enum';

export class FindPostsDto {
    @IsOptional()
    @IsEnum(PetStatus)
    type?: PetStatus;

    @IsOptional()
    @IsEnum(PetType)
    animalType?: PetType;

    @IsOptional()
    @IsNumber()
    @Type(() => Number)
    latitude?: number;

    @IsOptional()
    @IsNumber()
    @Type(() => Number)
    longitude?: number;

    @IsOptional()
    @IsNumber()
    @Type(() => Number)
    radius?: number;

    @IsOptional()
    @IsString()
    cursor?: string;

    @IsOptional()
    @IsUUID()
    userId?: string;

    @IsOptional()
    @IsUUID()
    petProfileId?: string;

    @IsOptional()
    @IsNumber()
    @Type(() => Number)
    limit?: number = 20;
}
