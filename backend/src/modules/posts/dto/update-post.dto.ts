import { IsString, IsOptional, IsEnum, IsNumber, IsArray, IsDateString } from 'class-validator';
import { Type } from 'class-transformer';
import { PetStatus, PetType } from '../../pets/enums/pet.enum';

export class UpdatePostDto {
    @IsOptional()
    @IsEnum(PetStatus)
    type?: PetStatus;

    @IsOptional()
    @IsString()
    description?: string;

    @IsOptional()
    @IsArray()
    @IsString({ each: true })
    imageUrls?: string[];

    @IsOptional()
    @IsNumber()
    @Type(() => Number)
    latitude?: number;

    @IsOptional()
    @IsNumber()
    @Type(() => Number)
    longitude?: number;

    @IsOptional()
    @IsDateString()
    lastSeenAt?: string;

    @IsOptional()
    @IsEnum(PetType)
    animalType?: PetType;

    @IsOptional()
    @IsString()
    breed?: string;

    @IsOptional()
    @IsString()
    color?: string;

    @IsOptional()
    isResolved?: boolean;
}
