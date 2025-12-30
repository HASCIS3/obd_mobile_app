// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoachModel _$CoachModelFromJson(Map<String, dynamic> json) => CoachModel(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num?)?.toInt(),
  nom: json['nom'] as String,
  prenom: json['prenom'] as String,
  telephone: json['telephone'] as String?,
  email: json['email'] as String?,
  specialite: json['specialite'] as String?,
  photo: json['photo'] as String?,
  statut: json['statut'] as String?,
  dateEmbauche: json['date_embauche'] == null
      ? null
      : DateTime.parse(json['date_embauche'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$CoachModelToJson(CoachModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'nom': instance.nom,
      'prenom': instance.prenom,
      'telephone': instance.telephone,
      'email': instance.email,
      'specialite': instance.specialite,
      'photo': instance.photo,
      'statut': instance.statut,
      'date_embauche': instance.dateEmbauche?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
