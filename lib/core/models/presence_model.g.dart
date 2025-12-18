// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PresenceModel _$PresenceModelFromJson(Map<String, dynamic> json) =>
    PresenceModel(
      id: (json['id'] as num).toInt(),
      athleteId: (json['athlete_id'] as num).toInt(),
      disciplineId: (json['discipline_id'] as num).toInt(),
      coachId: (json['coach_id'] as num?)?.toInt(),
      date: DateTime.parse(json['date'] as String),
      present: json['present'] as bool,
      remarque: json['remarque'] as String?,
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

Map<String, dynamic> _$PresenceModelToJson(PresenceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'athlete_id': instance.athleteId,
      'discipline_id': instance.disciplineId,
      'coach_id': instance.coachId,
      'date': instance.date.toIso8601String(),
      'present': instance.present,
      'remarque': instance.remarque,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'athlete': instance.athlete,
      'discipline': instance.discipline,
    };
