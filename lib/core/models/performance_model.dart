import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'athlete_model.dart';
import 'discipline_model.dart';

part 'performance_model.g.dart';

/// Contextes de performance
enum ContextePerformance {
  @JsonValue('entrainement')
  entrainement,
  @JsonValue('match')
  match,
  @JsonValue('competition')
  competition,
  @JsonValue('test_physique')
  testPhysique,
}

/// Résultats de match
enum ResultatMatch {
  @JsonValue('victoire')
  victoire,
  @JsonValue('defaite')
  defaite,
  @JsonValue('nul')
  nul,
}

/// Types de médaille
enum TypeMedaille {
  @JsonValue('or')
  or,
  @JsonValue('argent')
  argent,
  @JsonValue('bronze')
  bronze,
}

/// Modèle performance
@JsonSerializable()
class PerformanceModel extends Equatable {
  final int id;
  @JsonKey(name: 'athlete_id')
  final int athleteId;
  @JsonKey(name: 'discipline_id')
  final int disciplineId;
  @JsonKey(name: 'date_evaluation')
  final DateTime dateEvaluation;
  @JsonKey(name: 'type_evaluation')
  final String? typeEvaluation;
  final ContextePerformance contexte;
  @JsonKey(name: 'resultat_match')
  final ResultatMatch? resultatMatch;
  @JsonKey(name: 'points_marques')
  final int? pointsMarques;
  @JsonKey(name: 'points_encaisses')
  final int? pointsEncaisses;
  final double? score;
  final String? unite;
  final String? observations;
  final String? competition;
  final String? adversaire;
  final String? lieu;
  final int? classement;
  final TypeMedaille? medaille;
  @JsonKey(name: 'note_physique')
  final int? notePhysique;
  @JsonKey(name: 'note_technique')
  final int? noteTechnique;
  @JsonKey(name: 'note_comportement')
  final int? noteComportement;
  @JsonKey(name: 'note_globale')
  final double? noteGlobale;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  // Relations (optionnelles)
  final AthleteModel? athlete;
  final DisciplineModel? discipline;

  const PerformanceModel({
    required this.id,
    required this.athleteId,
    required this.disciplineId,
    required this.dateEvaluation,
    this.typeEvaluation,
    required this.contexte,
    this.resultatMatch,
    this.pointsMarques,
    this.pointsEncaisses,
    this.score,
    this.unite,
    this.observations,
    this.competition,
    this.adversaire,
    this.lieu,
    this.classement,
    this.medaille,
    this.notePhysique,
    this.noteTechnique,
    this.noteComportement,
    this.noteGlobale,
    this.createdAt,
    this.updatedAt,
    this.athlete,
    this.discipline,
  });

  /// Score formaté avec unité
  String get scoreFormate {
    if (score == null) return 'N/A';
    return '${score!.toStringAsFixed(2)} ${unite ?? ''}'.trim();
  }

  /// Libellé du classement
  String? get classementLibelle {
    if (classement == null) return null;
    final suffixe = classement == 1 ? 'er' : 'ème';
    return '$classement$suffixe';
  }

  /// Vérifie si c'est un podium
  bool get estPodium => classement != null && classement! <= 3;

  /// Vérifie si c'est une performance en compétition
  bool get estEnCompetition => competition != null && competition!.isNotEmpty;

  /// Score du match formaté
  String? get scoreMatch {
    if (pointsMarques == null || pointsEncaisses == null) return null;
    return '$pointsMarques - $pointsEncaisses';
  }

  /// Libellé du contexte
  String get contexteLibelle {
    switch (contexte) {
      case ContextePerformance.entrainement:
        return 'Entraînement';
      case ContextePerformance.match:
        return 'Match';
      case ContextePerformance.competition:
        return 'Compétition';
      case ContextePerformance.testPhysique:
        return 'Test physique';
    }
  }

  /// Libellé du résultat match
  String? get resultatMatchLibelle {
    switch (resultatMatch) {
      case ResultatMatch.victoire:
        return 'Victoire';
      case ResultatMatch.defaite:
        return 'Défaite';
      case ResultatMatch.nul:
        return 'Nul';
      case null:
        return null;
    }
  }

  /// Libellé de la médaille
  String? get medailleLibelle {
    switch (medaille) {
      case TypeMedaille.or:
        return 'Or 🥇';
      case TypeMedaille.argent:
        return 'Argent 🥈';
      case TypeMedaille.bronze:
        return 'Bronze 🥉';
      case null:
        return null;
    }
  }

  factory PerformanceModel.fromJson(Map<String, dynamic> json) =>
      _$PerformanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$PerformanceModelToJson(this);

  PerformanceModel copyWith({
    int? id,
    int? athleteId,
    int? disciplineId,
    DateTime? dateEvaluation,
    String? typeEvaluation,
    ContextePerformance? contexte,
    ResultatMatch? resultatMatch,
    int? pointsMarques,
    int? pointsEncaisses,
    double? score,
    String? unite,
    String? observations,
    String? competition,
    String? adversaire,
    String? lieu,
    int? classement,
    TypeMedaille? medaille,
    int? notePhysique,
    int? noteTechnique,
    int? noteComportement,
    double? noteGlobale,
    DateTime? createdAt,
    DateTime? updatedAt,
    AthleteModel? athlete,
    DisciplineModel? discipline,
  }) {
    return PerformanceModel(
      id: id ?? this.id,
      athleteId: athleteId ?? this.athleteId,
      disciplineId: disciplineId ?? this.disciplineId,
      dateEvaluation: dateEvaluation ?? this.dateEvaluation,
      typeEvaluation: typeEvaluation ?? this.typeEvaluation,
      contexte: contexte ?? this.contexte,
      resultatMatch: resultatMatch ?? this.resultatMatch,
      pointsMarques: pointsMarques ?? this.pointsMarques,
      pointsEncaisses: pointsEncaisses ?? this.pointsEncaisses,
      score: score ?? this.score,
      unite: unite ?? this.unite,
      observations: observations ?? this.observations,
      competition: competition ?? this.competition,
      adversaire: adversaire ?? this.adversaire,
      lieu: lieu ?? this.lieu,
      classement: classement ?? this.classement,
      medaille: medaille ?? this.medaille,
      notePhysique: notePhysique ?? this.notePhysique,
      noteTechnique: noteTechnique ?? this.noteTechnique,
      noteComportement: noteComportement ?? this.noteComportement,
      noteGlobale: noteGlobale ?? this.noteGlobale,
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
        dateEvaluation,
        typeEvaluation,
        contexte,
        resultatMatch,
        pointsMarques,
        pointsEncaisses,
        score,
        unite,
        observations,
        competition,
        adversaire,
        lieu,
        classement,
        medaille,
        notePhysique,
        noteTechnique,
        noteComportement,
        noteGlobale,
        createdAt,
        updatedAt,
        athlete,
        discipline,
      ];
}
