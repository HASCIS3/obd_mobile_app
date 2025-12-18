// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'athlete_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AthleteModel _$AthleteModelFromJson(Map<String, dynamic> json) => AthleteModel(
  id: (json['id'] as num).toInt(),
  nom: json['nom'] as String,
  prenom: json['prenom'] as String,
  dateNaissance: json['date_naissance'] == null
      ? null
      : DateTime.parse(json['date_naissance'] as String),
  sexe: json['sexe'] as String,
  telephone: json['telephone'] as String?,
  email: json['email'] as String?,
  adresse: json['adresse'] as String?,
  photo: json['photo'] as String?,
  nomTuteur: json['nom_tuteur'] as String?,
  telephoneTuteur: json['telephone_tuteur'] as String?,
  dateInscription: json['date_inscription'] == null
      ? null
      : DateTime.parse(json['date_inscription'] as String),
  actif: json['actif'] as bool? ?? true,
  bulletinToken: json['bulletin_token'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  disciplines: (json['disciplines'] as List<dynamic>?)
      ?.map((e) => DisciplineModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  tauxPresence: (json['taux_presence'] as num?)?.toDouble(),
  arrieres: (json['arrieres'] as num?)?.toDouble(),
);

Map<String, dynamic> _$AthleteModelToJson(AthleteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
      'prenom': instance.prenom,
      'date_naissance': instance.dateNaissance?.toIso8601String(),
      'sexe': instance.sexe,
      'telephone': instance.telephone,
      'email': instance.email,
      'adresse': instance.adresse,
      'photo': instance.photo,
      'nom_tuteur': instance.nomTuteur,
      'telephone_tuteur': instance.telephoneTuteur,
      'date_inscription': instance.dateInscription?.toIso8601String(),
      'actif': instance.actif,
      'bulletin_token': instance.bulletinToken,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'disciplines': instance.disciplines,
      'taux_presence': instance.tauxPresence,
      'arrieres': instance.arrieres,
    };
