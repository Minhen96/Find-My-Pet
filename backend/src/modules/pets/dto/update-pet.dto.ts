import { IsString, IsOptional, IsEnum, IsNumber, IsArray } from 'class-validator';
import { PetType, PetStatus } from '../enums/pet.enum';

export class UpdatePetDto {
    @IsOptional()
    @IsArray()
    @IsString({ each: true })
    imageUrls?: string[];

    @IsOptional()
    @IsString()
    name?: string;

    @IsOptional()
    @IsString()
    breed?: string;

    @IsOptional()
    @IsEnum(PetType)
    type?: PetType;

    @IsOptional()
    @IsEnum(PetStatus)
    status?: PetStatus;

    @IsOptional()
    @IsString()
    description?: string;

    @IsOptional()
    @IsNumber()
    latitude?: number;

    @IsOptional()
    @IsNumber()
    longitude?: number;
}
