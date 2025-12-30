// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'licence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LicenceModel _$LicenceModelFromJson(Map<String, dynamic> json) => LicenceModel(
  id: (json['id'] as num).toInt(),
  athleteId: (json['athlete_id'] as num).toInt(),
  athleteNom: json['athlete_nom'] as String?,
  numero: json['numero'] as String,
  type: json['type'] as String?,
  dateEmission: DateTime.parse(json['date_emission'] as String),
  dateExpiration: DateTime.parse(json['date_expiration'] as String),
  statut: $enumDecodeNullable(_$StatutLicenceEnumMap, json['statut']),
  federation: json['federation'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$LicenceModelToJson(LicenceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'athlete_id': instance.athleteId,
      'athlete_nom': instance.athleteNom,
      'numero': instance.numero,
      'type': instance.type,
      'date_emission': instance.dateEmission.toIso8601String(),
      'date_expiration': instance.dateExpiration.toIso8601String(),
      'statut': _$StatutLicenceEnumMap[instance.statut],
      'federation': instance.federation,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$StatutLicenceEnumMap = {
  StatutLicence.valide: 'valide',
  StatutLicence.expirant: 'expirant',
  StatutLicence.expiree: 'expiree',
  StatutLicence.enAttente: 'en_attente',
};
