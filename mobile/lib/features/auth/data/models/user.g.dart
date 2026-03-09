// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  email: json['email'] as String,
  fullName: json['fullName'] as String,
  phoneNumber: json['phoneNumber'] as String?,
  role: json['role'] as String? ?? 'user',
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'fullName': instance.fullName,
  'phoneNumber': instance.phoneNumber,
  'role': instance.role,
};
