// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suivi_scolaire_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuiviScolaireModel _$SuiviScolaireModelFromJson(Map<String, dynamic> json) =>
    SuiviScolaireModel(
      id: (json['id'] as num).toInt(),
      athleteId: (json['athlete_id'] as num).toInt(),
      athleteNom: json['athlete_nom'] as String?,
      anneeScolaire: json['annee_scolaire'] as String,
      trimestre: (json['trimestre'] as num?)?.toInt(),
      etablissement: json['etablissement'] as String?,
      classe: json['classe'] as String?,
      moyenneGenerale: (json['moyenne_generale'] as num?)?.toDouble(),
      comportement: json['comportement'] as String?,
      remarques: json['remarques'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$SuiviScolaireModelToJson(SuiviScolaireModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'athlete_id': instance.athleteId,
      'athlete_nom': instance.athleteNom,
      'annee_scolaire': instance.anneeScolaire,
      'trimestre': instance.trimestre,
      'etablissement': instance.etablissement,
      'classe': instance.classe,
      'moyenne_generale': instance.moyenneGenerale,
      'comportement': instance.comportement,
      'remarques': instance.remarques,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
