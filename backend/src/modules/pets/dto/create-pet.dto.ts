import {
    IsEnum,
    IsNotEmpty,
    IsOptional,
    IsString,
    IsNumber,
    IsDateString,
    Min,
    Max,
} from 'class-validator';
import { PetType, PetStatus } from '../enums/pet.enum';
import { Type } from 'class-transformer';

export class CreatePetDto {
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
}
