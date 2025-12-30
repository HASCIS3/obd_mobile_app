// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rencontre_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RencontreModel _$RencontreModelFromJson(Map<String, dynamic> json) =>
    RencontreModel(
      id: (json['id'] as num).toInt(),
      disciplineId: (json['discipline_id'] as num?)?.toInt(),
      disciplineNom: json['discipline_nom'] as String?,
      dateMatch: DateTime.parse(json['date_match'] as String),
      heureMatch: json['heure_match'] as String?,
      typeMatch: $enumDecodeNullable(_$TypeMatchEnumMap, json['type_match']),
      adversaire: json['adversaire'] as String?,
      lieu: json['lieu'] as String?,
      scoreObd: (json['score_obd'] as num?)?.toInt(),
      scoreAdversaire: (json['score_adversaire'] as num?)?.toInt(),
      resultat: $enumDecodeNullable(_$ResultatMatchEnumMap, json['resultat']),
      typeCompetition: json['type_competition'] as String?,
      saison: json['saison'] as String?,
      phase: json['phase'] as String?,
      description: json['description'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$RencontreModelToJson(RencontreModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'discipline_id': instance.disciplineId,
      'discipline_nom': instance.disciplineNom,
      'date_match': instance.dateMatch.toIso8601String(),
      'heure_match': instance.heureMatch,
      'type_match': _$TypeMatchEnumMap[instance.typeMatch],
      'adversaire': instance.adversaire,
      'lieu': instance.lieu,
      'score_obd': instance.scoreObd,
      'score_adversaire': instance.scoreAdversaire,
      'resultat': _$ResultatMatchEnumMap[instance.resultat],
      'type_competition': instance.typeCompetition,
      'saison': instance.saison,
      'phase': instance.phase,
      'description': instance.description,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$TypeMatchEnumMap = {
  TypeMatch.amical: 'amical',
  TypeMatch.championnat: 'championnat',
  TypeMatch.coupe: 'coupe',
  TypeMatch.tournoi: 'tournoi',
  TypeMatch.exhibition: 'exhibition',
};

const _$ResultatMatchEnumMap = {
  ResultatMatch.victoire: 'victoire',
  ResultatMatch.defaite: 'defaite',
  ResultatMatch.nul: 'nul',
  ResultatMatch.enCours: 'en_cours',
  ResultatMatch.aVenir: 'a_venir',
};

RencontreStats _$RencontreStatsFromJson(Map<String, dynamic> json) =>
    RencontreStats(
      total: (json['total'] as num?)?.toInt() ?? 0,
      victoires: (json['victoires'] as num?)?.toInt() ?? 0,
      defaites: (json['defaites'] as num?)?.toInt() ?? 0,
      nuls: (json['nuls'] as num?)?.toInt() ?? 0,
      aVenir: (json['a_venir'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$RencontreStatsToJson(RencontreStats instance) =>
    <String, dynamic>{
      'total': instance.total,
      'victoires': instance.victoires,
      'defaites': instance.defaites,
      'nuls': instance.nuls,
      'a_venir': instance.aVenir,
    };
