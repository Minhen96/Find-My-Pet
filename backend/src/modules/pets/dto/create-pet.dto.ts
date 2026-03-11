import {
    IsEnum,
    IsNotEmpty,
    IsOptional,
    IsString,
    IsNumber,
    IsDateString,
    Min,
    Max,
    IsArray,
    MaxLength,
} from 'class-validator';
import { PetType, PetStatus } from '../enums/pet.enum';
import { Type } from 'class-transformer';

export class CreatePetDto {
    @IsArray()
    @IsString({ each: true })
    @IsOptional()
    imageUrls?: string[];

    @IsString()
    @IsOptional()
    @MaxLength(100)
    name?: string;

    @IsEnum(PetType)
    @IsNotEmpty()
    type: PetType;

    @IsEnum(PetStatus)
    @IsNotEmpty()
    status: PetStatus;

    @IsString()
    @IsNotEmpty()
    breed: string;

    @IsString()
    @IsNotEmpty()
    color: string;

    @IsString()
    @IsOptional()
    description?: string;

    @IsNumber()
    @Min(-90)
    @Max(90)
    @Type(() => Number)
    latitude: number;

    @IsNumber()
    @Min(-180)
    @Max(180)
    @Type(() => Number)
    longitude: number;

    @IsDateString()
    @IsOptional()
    lastSeenAt?: string;

    @IsNumber()
    @IsOptional()
    @Type(() => Number)
    age?: number;

    @IsString()
    @IsOptional()
    gender?: string;

    @IsString()
    @IsOptional()
    markings?: string;

    @IsString()
    @IsOptional()
    healthNotes?: string;

    @IsString()
    @IsOptional()
    microchipId?: string;
}
