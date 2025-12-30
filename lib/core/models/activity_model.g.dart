// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityModel _$ActivityModelFromJson(Map<String, dynamic> json) =>
    ActivityModel(
      id: (json['id'] as num).toInt(),
      titre: json['titre'] as String,
      description: json['description'] as String?,
      type: $enumDecodeNullable(_$TypeActivityEnumMap, json['type']),
      debut: DateTime.parse(json['debut'] as String),
      fin: json['fin'] == null ? null : DateTime.parse(json['fin'] as String),
      lieu: json['lieu'] as String?,
      image: json['image'] as String?,
      statut: $enumDecodeNullable(_$StatutActivityEnumMap, json['statut']),
      disciplineId: (json['discipline_id'] as num?)?.toInt(),
      disciplineNom: json['discipline_nom'] as String?,
      nbParticipants: (json['nb_participants'] as num?)?.toInt(),
      maxParticipants: (json['max_participants'] as num?)?.toInt(),
      tarif: (json['tarif'] as num?)?.toDouble(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ActivityModelToJson(ActivityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titre': instance.titre,
      'description': instance.description,
      'type': _$TypeActivityEnumMap[instance.type],
      'debut': instance.debut.toIso8601String(),
      'fin': instance.fin?.toIso8601String(),
      'lieu': instance.lieu,
      'image': instance.image,
      'statut': _$StatutActivityEnumMap[instance.statut],
      'discipline_id': instance.disciplineId,
      'discipline_nom': instance.disciplineNom,
      'nb_participants': instance.nbParticipants,
      'max_participants': instance.maxParticipants,
      'tarif': instance.tarif,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$TypeActivityEnumMap = {
  TypeActivity.stage: 'stage',
  TypeActivity.competition: 'competition',
  TypeActivity.evenement: 'evenement',
  TypeActivity.reunion: 'reunion',
  TypeActivity.entrainement: 'entrainement',
  TypeActivity.autre: 'autre',
};

const _$StatutActivityEnumMap = {
  StatutActivity.planifie: 'planifie',
  StatutActivity.enCours: 'en_cours',
  StatutActivity.termine: 'termine',
  StatutActivity.annule: 'annule',
};

ActivityStats _$ActivityStatsFromJson(Map<String, dynamic> json) =>
    ActivityStats(
      total: (json['total'] as num?)?.toInt() ?? 0,
      aVenir: (json['a_venir'] as num?)?.toInt() ?? 0,
      enCours: (json['en_cours'] as num?)?.toInt() ?? 0,
      terminees: (json['terminees'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ActivityStatsToJson(ActivityStats instance) =>
    <String, dynamic>{
      'total': instance.total,
      'a_venir': instance.aVenir,
      'en_cours': instance.enCours,
      'terminees': instance.terminees,
    };
