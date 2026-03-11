import { IsEnum, IsOptional, IsNumber, Min, Max, IsString } from 'class-validator';
import { Type } from 'class-transformer';
import { PetType, PetStatus } from '../enums/pet.enum';

export class FindPetsDto {
    @IsOptional()
    @IsEnum(PetType)
    type?: PetType;

    @IsOptional()
    @IsEnum(PetStatus)
    status?: PetStatus;

    @IsOptional()
    @IsNumber()
    @Min(-90)
    @Max(90)
    @Type(() => Number)
    latitude?: number;

    @IsOptional()
    @IsNumber()
    @Min(-180)
    @Max(180)
    @Type(() => Number)
    longitude?: number;

    @IsOptional()
    @IsNumber()
    @Min(0)
    @Type(() => Number)
    radius?: number; // In meters

    // --- Pagination ---
    @IsOptional()
    @IsNumber()
    @Min(1)
    @Type(() => Number)
    limit?: number; // Number of items to fetch

    @IsOptional()
    cursor?: string; // Cursor for infinite scrolling (timestamp of the last item)

    @IsOptional()
    @IsString()
    userId?: string;
}
