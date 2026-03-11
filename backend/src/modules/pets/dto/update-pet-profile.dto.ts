import { PartialType } from '@nestjs/swagger';
import { CreatePetProfileDto } from './create-pet-profile.dto';

export class UpdatePetProfileDto extends PartialType(CreatePetProfileDto) {}
