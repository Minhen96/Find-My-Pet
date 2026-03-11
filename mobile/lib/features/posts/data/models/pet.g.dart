// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Pet _$PetFromJson(Map<String, dynamic> json) => _Pet(
  id: json['id'] as String,
  name: json['name'] as String?,
  type: $enumDecode(_$PetTypeEnumMap, json['type']),
  status: $enumDecode(_$PetStatusEnumMap, json['status']),
  breed: json['breed'] as String,
  color: json['color'] as String,
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
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$PetToJson(_Pet instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': _$PetTypeEnumMap[instance.type]!,
  'status': _$PetStatusEnumMap[instance.status]!,
  'breed': instance.breed,
  'color': instance.color,
  'description': instance.description,
  'images': instance.images,
  'location': instance.location,
  'lastSeenAt': instance.lastSeenAt?.toIso8601String(),
  'isResolved': instance.isResolved,
  'poster': instance.poster,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$PetTypeEnumMap = {
  PetType.dog: 'DOG',
  PetType.cat: 'CAT',
  PetType.bird: 'BIRD',
  PetType.other: 'OTHER',
};

const _$PetStatusEnumMap = {
  PetStatus.lost: 'LOST',
  PetStatus.found: 'FOUND',
  PetStatus.stray: 'STRAY',
  PetStatus.rescued: 'RESCUED',
  PetStatus.moment: 'MOMENT',
};
