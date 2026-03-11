import { IsString, IsOptional, IsEnum, IsNumber, IsArray, MaxLength } from 'class-validator';
import { PetType, PetStatus } from '../enums/pet.enum';

export class UpdatePetDto {
    @IsOptional()
    @IsArray()
    @IsString({ each: true })
    imageUrls?: string[];

    @IsOptional()
    @IsString()
    @MaxLength(100)
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

    @IsOptional()
    @IsNumber()
    age?: number;

    @IsOptional()
    @IsString()
    gender?: string;

    @IsOptional()
    @IsString()
    markings?: string;

    @IsOptional()
    @IsString()
    healthNotes?: string;

    @IsOptional()
    @IsString()
    microchipId?: string;
}
