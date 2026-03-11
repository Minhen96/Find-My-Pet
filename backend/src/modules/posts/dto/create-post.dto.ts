import { IsString, IsEnum, IsNumber, IsOptional, IsArray, IsDateString } from 'class-validator';
import { Type } from 'class-transformer';
import { PetStatus, PetType } from '../../pets/enums/pet.enum';

export class CreatePostDto {
    @IsEnum(PetStatus)
    type: PetStatus;

    @IsString()
    @IsOptional()
    description?: string;

    @IsArray()
    @IsString({ each: true })
    @IsOptional()
    imageUrls?: string[];

    @IsNumber()
    @Type(() => Number)
    latitude: number;

    @IsNumber()
    @Type(() => Number)
    longitude: number;

    @IsNumber()
    @IsOptional()
    @Type(() => Number)
    radius?: number;

    @IsDateString()
    @IsOptional()
    lastSeenAt?: string;

    @IsString()
    @IsOptional()
    petProfileId?: string;

    // For ad-hoc posts
    @IsEnum(PetType)
    @IsOptional()
    animalType?: PetType;

    @IsString()
    @IsOptional()
    breed?: string;

    @IsString()
    @IsOptional()
    color?: string;
}
