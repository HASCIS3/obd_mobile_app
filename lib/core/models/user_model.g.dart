// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: (json['id'] as num).toInt(),
  athleteId: (json['athlete_id'] as num?)?.toInt(),
  name: json['name'] as String,
  email: json['email'] as String,
  role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']),
  photo: json['photo'] as String?,
  emailVerifiedAt: json['email_verified_at'] == null
      ? null
      : DateTime.parse(json['email_verified_at'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'athlete_id': instance.athleteId,
  'name': instance.name,
  'email': instance.email,
  'role': _$UserRoleEnumMap[instance.role],
  'photo': instance.photo,
  'email_verified_at': instance.emailVerifiedAt?.toIso8601String(),
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

const _$UserRoleEnumMap = {UserRole.admin: 'admin', UserRole.coach: 'coach'};
