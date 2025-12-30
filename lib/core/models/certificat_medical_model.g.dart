// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificat_medical_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CertificatMedicalModel _$CertificatMedicalModelFromJson(
  Map<String, dynamic> json,
) => CertificatMedicalModel(
  id: (json['id'] as num).toInt(),
  athleteId: (json['athlete_id'] as num).toInt(),
  athleteNom: json['athlete_nom'] as String?,
  type: json['type'] as String?,
  dateEmission: DateTime.parse(json['date_emission'] as String),
  dateExpiration: DateTime.parse(json['date_expiration'] as String),
  medecin: json['medecin'] as String?,
  fichier: json['fichier'] as String?,
  remarques: json['remarques'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$CertificatMedicalModelToJson(
  CertificatMedicalModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'athlete_id': instance.athleteId,
  'athlete_nom': instance.athleteNom,
  'type': instance.type,
  'date_emission': instance.dateEmission.toIso8601String(),
  'date_expiration': instance.dateExpiration.toIso8601String(),
  'medecin': instance.medecin,
  'fichier': instance.fichier,
  'remarques': instance.remarques,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
