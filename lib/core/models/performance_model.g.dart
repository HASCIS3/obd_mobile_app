// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PerformanceModel _$PerformanceModelFromJson(Map<String, dynamic> json) =>
    PerformanceModel(
      id: (json['id'] as num).toInt(),
      athleteId: (json['athlete_id'] as num).toInt(),
      disciplineId: (json['discipline_id'] as num).toInt(),
      dateEvaluation: DateTime.parse(json['date_evaluation'] as String),
      typeEvaluation: json['type_evaluation'] as String?,
      contexte: $enumDecode(_$ContextePerformanceEnumMap, json['contexte']),
      resultatMatch: $enumDecodeNullable(
        _$ResultatMatchEnumMap,
        json['resultat_match'],
      ),
      pointsMarques: (json['points_marques'] as num?)?.toInt(),
      pointsEncaisses: (json['points_encaisses'] as num?)?.toInt(),
      score: (json['score'] as num?)?.toDouble(),
      unite: json['unite'] as String?,
      observations: json['observations'] as String?,
      competition: json['competition'] as String?,
      adversaire: json['adversaire'] as String?,
      lieu: json['lieu'] as String?,
      classement: (json['classement'] as num?)?.toInt(),
      medaille: $enumDecodeNullable(_$TypeMedailleEnumMap, json['medaille']),
      notePhysique: (json['note_physique'] as num?)?.toInt(),
      noteTechnique: (json['note_technique'] as num?)?.toInt(),
      noteComportement: (json['note_comportement'] as num?)?.toInt(),
      noteGlobale: (json['note_globale'] as num?)?.toDouble(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      athlete: json['athlete'] == null
          ? null
          : AthleteModel.fromJson(json['athlete'] as Map<String, dynamic>),
      discipline: json['discipline'] == null
          ? null
          : DisciplineModel.fromJson(
              json['discipline'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$PerformanceModelToJson(PerformanceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'athlete_id': instance.athleteId,
      'discipline_id': instance.disciplineId,
      'date_evaluation': instance.dateEvaluation.toIso8601String(),
      'type_evaluation': instance.typeEvaluation,
      'contexte': _$ContextePerformanceEnumMap[instance.contexte]!,
      'resultat_match': _$ResultatMatchEnumMap[instance.resultatMatch],
      'points_marques': instance.pointsMarques,
      'points_encaisses': instance.pointsEncaisses,
      'score': instance.score,
      'unite': instance.unite,
      'observations': instance.observations,
      'competition': instance.competition,
      'adversaire': instance.adversaire,
      'lieu': instance.lieu,
      'classement': instance.classement,
      'medaille': _$TypeMedailleEnumMap[instance.medaille],
      'note_physique': instance.notePhysique,
      'note_technique': instance.noteTechnique,
      'note_comportement': instance.noteComportement,
      'note_globale': instance.noteGlobale,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'athlete': instance.athlete,
      'discipline': instance.discipline,
    };

const _$ContextePerformanceEnumMap = {
  ContextePerformance.entrainement: 'entrainement',
  ContextePerformance.match: 'match',
  ContextePerformance.competition: 'competition',
  ContextePerformance.testPhysique: 'test_physique',
};

const _$ResultatMatchEnumMap = {
  ResultatMatch.victoire: 'victoire',
  ResultatMatch.defaite: 'defaite',
  ResultatMatch.nul: 'nul',
};

const _$TypeMedailleEnumMap = {
  TypeMedaille.or: 'or',
  TypeMedaille.argent: 'argent',
  TypeMedaille.bronze: 'bronze',
};
