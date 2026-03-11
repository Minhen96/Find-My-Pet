import { IsString, IsEnum, IsNumber, IsOptional, IsArray, MaxLength } from 'class-validator';
import { Type } from 'class-transformer';
import { PetType } from '../enums/pet.enum';

export class CreatePetProfileDto {
    @IsString()
    @MaxLength(100)
    name: string;

    @IsEnum(PetType)
    type: PetType;

    @IsString()
    breed: string;

    @IsNumber()
    @IsOptional()
    @Type(() => Number)
    age?: number;

    @IsString()
    @IsOptional()
    gender?: string;

    @IsString()
    color: string;

    @IsString()
    @IsOptional()
    markings?: string;

    @IsString()
    @IsOptional()
    healthNotes?: string;

    @IsString()
    @IsOptional()
    microchipId?: string;

    @IsOptional()
    @IsArray()
    @IsString({ each: true })
    imageUrls?: string[];
}
