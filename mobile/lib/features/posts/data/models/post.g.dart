// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Post _$PostFromJson(Map<String, dynamic> json) => _Post(
  id: json['id'] as String,
  type: $enumDecode(_$PostTypeEnumMap, json['type']),
  description: json['description'] as String?,
  images:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  location: json['location'],
  lastSeenAt: json['lastSeenAt'] == null
      ? null
      : DateTime.parse(json['lastSeenAt'] as String),
  isResolved: json['isResolved'] as bool? ?? false,
  poster: json['poster'] == null
      ? null
      : User.fromJson(json['poster'] as Map<String, dynamic>),
  petProfile: json['petProfile'] == null
      ? null
      : PetProfile.fromJson(json['petProfile'] as Map<String, dynamic>),
  animalType: $enumDecodeNullable(_$AnimalTypeEnumMap, json['animalType']),
  breed: json['breed'] as String?,
  color: json['color'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$PostToJson(_Post instance) => <String, dynamic>{
  'id': instance.id,
  'type': _$PostTypeEnumMap[instance.type]!,
  'description': instance.description,
  'images': instance.images,
  'location': instance.location,
  'lastSeenAt': instance.lastSeenAt?.toIso8601String(),
  'isResolved': instance.isResolved,
  'poster': instance.poster,
  'petProfile': instance.petProfile,
  'animalType': _$AnimalTypeEnumMap[instance.animalType],
  'breed': instance.breed,
  'color': instance.color,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$PostTypeEnumMap = {
  PostType.lost: 'LOST',
  PostType.found: 'FOUND',
  PostType.sighted: 'SIGHTED',
  PostType.stray: 'STRAY',
  PostType.rescued: 'RESCUED',
  PostType.moment: 'MOMENT',
};

const _$AnimalTypeEnumMap = {
  AnimalType.dog: 'DOG',
  AnimalType.cat: 'CAT',
  AnimalType.bird: 'BIRD',
  AnimalType.rabbit: 'RABBIT',
  AnimalType.other: 'OTHER',
};
