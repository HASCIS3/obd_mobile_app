import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'athlete_model.dart';
import 'discipline_model.dart';

part 'presence_model.g.dart';

/// Modèle présence
@JsonSerializable()
class PresenceModel extends Equatable {
  final int id;
  @JsonKey(name: 'athlete_id')
  final int athleteId;
  @JsonKey(name: 'discipline_id')
  final int disciplineId;
  @JsonKey(name: 'coach_id')
  final int? coachId;
  final DateTime date;
  final bool present;
  final String? remarque;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  // Relations (optionnelles)
  final AthleteModel? athlete;
  final DisciplineModel? discipline;

  const PresenceModel({
    required this.id,
    required this.athleteId,
    required this.disciplineId,
    this.coachId,
    required this.date,
    required this.present,
    this.remarque,
    this.createdAt,
    this.updatedAt,
    this.athlete,
    this.discipline,
  });

  /// Libellé du statut
  String get statutLibelle => present ? 'Présent' : 'Absent';

  /// Vérifie si c'est une présence
  bool get estPresent => present;

  /// Vérifie si c'est une absence
  bool get estAbsent => !present;

  factory PresenceModel.fromJson(Map<String, dynamic> json) =>
      _$PresenceModelFromJson(json);

  Map<String, dynamic> toJson() => _$PresenceModelToJson(this);

  PresenceModel copyWith({
    int? id,
    int? athleteId,
    int? disciplineId,
    int? coachId,
    DateTime? date,
    bool? present,
    String? remarque,
    DateTime? createdAt,
    DateTime? updatedAt,
    AthleteModel? athlete,
    DisciplineModel? discipline,
  }) {
    return PresenceModel(
      id: id ?? this.id,
      athleteId: athleteId ?? this.athleteId,
      disciplineId: disciplineId ?? this.disciplineId,
      coachId: coachId ?? this.coachId,
      date: date ?? this.date,
      present: present ?? this.present,
      remarque: remarque ?? this.remarque,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      athlete: athlete ?? this.athlete,
      discipline: discipline ?? this.discipline,
    );
  }

  @override
  List<Object?> get props => [
        id,
        athleteId,
        disciplineId,
        coachId,
        date,
        present,
        remarque,
        createdAt,
        updatedAt,
        athlete,
        discipline,
      ];
}

/// Modèle pour créer/modifier une présence
class PresenceInput {
  final int athleteId;
  final int disciplineId;
  final DateTime date;
  final bool present;
  final String? remarque;

  const PresenceInput({
    required this.athleteId,
    required this.disciplineId,
    required this.date,
    required this.present,
    this.remarque,
  });

  Map<String, dynamic> toJson() => {
        'athlete_id': athleteId,
        'discipline_id': disciplineId,
        'date': date.toIso8601String().split('T').first,
        'present': present,
        if (remarque != null) 'remarque': remarque,
      };
}

/// Statistiques de présence
class PresenceStats extends Equatable {
  final int total;
  final int presents;
  final int absents;
  final double taux;

  const PresenceStats({
    required this.total,
    required this.presents,
    required this.absents,
    required this.taux,
  });

  factory PresenceStats.fromJson(Map<String, dynamic> json) => PresenceStats(
        total: json['total'] as int? ?? 0,
        presents: json['presents'] as int? ?? 0,
        absents: json['absents'] as int? ?? 0,
        taux: (json['taux'] as num?)?.toDouble() ?? 0.0,
      );

  @override
  List<Object?> get props => [total, presents, absents, taux];
}
