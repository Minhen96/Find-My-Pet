// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PetProfile _$PetProfileFromJson(Map<String, dynamic> json) => _PetProfile(
  id: json['id'] as String,
  name: json['name'] as String,
  type: $enumDecode(_$AnimalTypeEnumMap, json['type']),
  breed: json['breed'] as String,
  age: (json['age'] as num?)?.toInt(),
  gender: json['gender'] as String?,
  color: json['color'] as String,
  markings: json['markings'] as String?,
  healthNotes: json['healthNotes'] as String?,
  microchipId: json['microchipId'] as String?,
  images:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$PetProfileToJson(_PetProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$AnimalTypeEnumMap[instance.type]!,
      'breed': instance.breed,
      'age': instance.age,
      'gender': instance.gender,
      'color': instance.color,
      'markings': instance.markings,
      'healthNotes': instance.healthNotes,
      'microchipId': instance.microchipId,
      'images': instance.images,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$AnimalTypeEnumMap = {
  AnimalType.dog: 'DOG',
  AnimalType.cat: 'CAT',
  AnimalType.bird: 'BIRD',
  AnimalType.rabbit: 'RABBIT',
  AnimalType.other: 'OTHER',
};
