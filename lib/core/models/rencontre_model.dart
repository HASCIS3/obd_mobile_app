import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rencontre_model.g.dart';

/// Types de match
enum TypeMatch {
  @JsonValue('amical')
  amical,
  @JsonValue('championnat')
  championnat,
  @JsonValue('coupe')
  coupe,
  @JsonValue('tournoi')
  tournoi,
  @JsonValue('exhibition')
  exhibition,
}

/// Résultats possibles
enum ResultatMatch {
  @JsonValue('victoire')
  victoire,
  @JsonValue('defaite')
  defaite,
  @JsonValue('nul')
  nul,
  @JsonValue('en_cours')
  enCours,
  @JsonValue('a_venir')
  aVenir,
}

/// Modèle Rencontre/Match
@JsonSerializable()
class RencontreModel extends Equatable {
  final int id;
  @JsonKey(name: 'discipline_id')
  final int? disciplineId;
  @JsonKey(name: 'discipline_nom')
  final String? disciplineNom;
  @JsonKey(name: 'date_match')
  final DateTime dateMatch;
  @JsonKey(name: 'heure_match')
  final String? heureMatch;
  @JsonKey(name: 'type_match')
  final TypeMatch? typeMatch;
  final String? adversaire;
  final String? lieu;
  @JsonKey(name: 'score_obd')
  final int? scoreObd;
  @JsonKey(name: 'score_adversaire')
  final int? scoreAdversaire;
  final ResultatMatch? resultat;
  @JsonKey(name: 'type_competition')
  final String? typeCompetition;
  final String? saison;
  final String? phase;
  final String? description;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const RencontreModel({
    required this.id,
    this.disciplineId,
    this.disciplineNom,
    required this.dateMatch,
    this.heureMatch,
    this.typeMatch,
    this.adversaire,
    this.lieu,
    this.scoreObd,
    this.scoreAdversaire,
    this.resultat,
    this.typeCompetition,
    this.saison,
    this.phase,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  /// Score formaté (ex: "3 - 1")
  String get scoreFormate {
    if (scoreObd == null && scoreAdversaire == null) return '-';
    return '${scoreObd ?? 0} - ${scoreAdversaire ?? 0}';
  }

  /// Vérifie si le match est à venir
  bool get estAVenir => dateMatch.isAfter(DateTime.now());

  /// Vérifie si le match est terminé
  bool get estTermine => resultat != null && 
      resultat != ResultatMatch.enCours && 
      resultat != ResultatMatch.aVenir;

  /// Label du type de match
  String get typeMatchLabel {
    switch (typeMatch) {
      case TypeMatch.amical:
        return 'Amical';
      case TypeMatch.championnat:
        return 'Championnat';
      case TypeMatch.coupe:
        return 'Coupe';
      case TypeMatch.tournoi:
        return 'Tournoi';
      case TypeMatch.exhibition:
        return 'Exhibition';
      default:
        return 'Match';
    }
  }

  /// Label du résultat
  String get resultatLabel {
    switch (resultat) {
      case ResultatMatch.victoire:
        return 'Victoire';
      case ResultatMatch.defaite:
        return 'Défaite';
      case ResultatMatch.nul:
        return 'Nul';
      case ResultatMatch.enCours:
        return 'En cours';
      case ResultatMatch.aVenir:
        return 'À venir';
      default:
        return 'Non défini';
    }
  }

  factory RencontreModel.fromJson(Map<String, dynamic> json) =>
      _$RencontreModelFromJson(json);

  Map<String, dynamic> toJson() => _$RencontreModelToJson(this);

  RencontreModel copyWith({
    int? id,
    int? disciplineId,
    String? disciplineNom,
    DateTime? dateMatch,
    String? heureMatch,
    TypeMatch? typeMatch,
    String? adversaire,
    String? lieu,
    int? scoreObd,
    int? scoreAdversaire,
    ResultatMatch? resultat,
    String? typeCompetition,
    String? saison,
    String? phase,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RencontreModel(
      id: id ?? this.id,
      disciplineId: disciplineId ?? this.disciplineId,
      disciplineNom: disciplineNom ?? this.disciplineNom,
      dateMatch: dateMatch ?? this.dateMatch,
      heureMatch: heureMatch ?? this.heureMatch,
      typeMatch: typeMatch ?? this.typeMatch,
      adversaire: adversaire ?? this.adversaire,
      lieu: lieu ?? this.lieu,
      scoreObd: scoreObd ?? this.scoreObd,
      scoreAdversaire: scoreAdversaire ?? this.scoreAdversaire,
      resultat: resultat ?? this.resultat,
      typeCompetition: typeCompetition ?? this.typeCompetition,
      saison: saison ?? this.saison,
      phase: phase ?? this.phase,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        disciplineId,
        disciplineNom,
        dateMatch,
        heureMatch,
        typeMatch,
        adversaire,
        lieu,
        scoreObd,
        scoreAdversaire,
        resultat,
        typeCompetition,
        saison,
        phase,
        description,
        createdAt,
        updatedAt,
      ];
}

/// Stats des rencontres pour le dashboard
@JsonSerializable()
class RencontreStats extends Equatable {
  final int total;
  final int victoires;
  final int defaites;
  final int nuls;
  @JsonKey(name: 'a_venir')
  final int aVenir;

  const RencontreStats({
    this.total = 0,
    this.victoires = 0,
    this.defaites = 0,
    this.nuls = 0,
    this.aVenir = 0,
  });

  /// Pourcentage de victoires
  double get pourcentageVictoires {
    final joues = total - aVenir;
    if (joues == 0) return 0;
    return (victoires / joues) * 100;
  }

  factory RencontreStats.fromJson(Map<String, dynamic> json) =>
      _$RencontreStatsFromJson(json);

  Map<String, dynamic> toJson() => _$RencontreStatsToJson(this);

  @override
  List<Object?> get props => [total, victoires, defaites, nuls, aVenir];
}
