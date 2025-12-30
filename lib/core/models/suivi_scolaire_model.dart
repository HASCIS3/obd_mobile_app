import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'suivi_scolaire_model.g.dart';

/// Modèle Suivi Scolaire
@JsonSerializable()
class SuiviScolaireModel extends Equatable {
  final int id;
  @JsonKey(name: 'athlete_id')
  final int athleteId;
  @JsonKey(name: 'athlete_nom')
  final String? athleteNom;
  @JsonKey(name: 'annee_scolaire')
  final String anneeScolaire;
  final int? trimestre;
  final String? etablissement;
  final String? classe;
  @JsonKey(name: 'moyenne_generale')
  final double? moyenneGenerale;
  final String? comportement;
  final String? remarques;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const SuiviScolaireModel({
    required this.id,
    required this.athleteId,
    this.athleteNom,
    required this.anneeScolaire,
    this.trimestre,
    this.etablissement,
    this.classe,
    this.moyenneGenerale,
    this.comportement,
    this.remarques,
    this.createdAt,
    this.updatedAt,
  });

  /// Label du trimestre
  String get trimestreLabel {
    switch (trimestre) {
      case 1:
        return '1er Trimestre';
      case 2:
        return '2ème Trimestre';
      case 3:
        return '3ème Trimestre';
      default:
        return 'Trimestre $trimestre';
    }
  }

  /// Appréciation basée sur la moyenne
  String get appreciation {
    if (moyenneGenerale == null) return 'Non évalué';
    if (moyenneGenerale! >= 16) return 'Excellent';
    if (moyenneGenerale! >= 14) return 'Très bien';
    if (moyenneGenerale! >= 12) return 'Bien';
    if (moyenneGenerale! >= 10) return 'Passable';
    return 'Insuffisant';
  }

  factory SuiviScolaireModel.fromJson(Map<String, dynamic> json) =>
      _$SuiviScolaireModelFromJson(json);

  Map<String, dynamic> toJson() => _$SuiviScolaireModelToJson(this);

  SuiviScolaireModel copyWith({
    int? id,
    int? athleteId,
    String? athleteNom,
    String? anneeScolaire,
    int? trimestre,
    String? etablissement,
    String? classe,
    double? moyenneGenerale,
    String? comportement,
    String? remarques,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SuiviScolaireModel(
      id: id ?? this.id,
      athleteId: athleteId ?? this.athleteId,
      athleteNom: athleteNom ?? this.athleteNom,
      anneeScolaire: anneeScolaire ?? this.anneeScolaire,
      trimestre: trimestre ?? this.trimestre,
      etablissement: etablissement ?? this.etablissement,
      classe: classe ?? this.classe,
      moyenneGenerale: moyenneGenerale ?? this.moyenneGenerale,
      comportement: comportement ?? this.comportement,
      remarques: remarques ?? this.remarques,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        athleteId,
        athleteNom,
        anneeScolaire,
        trimestre,
        etablissement,
        classe,
        moyenneGenerale,
        comportement,
        remarques,
        createdAt,
        updatedAt,
      ];
}
