import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'combat_taekwondo_model.g.dart';

/// Statut du combat
enum StatutCombat {
  @JsonValue('a_venir')
  aVenir,
  @JsonValue('en_cours')
  enCours,
  @JsonValue('termine')
  termine,
  @JsonValue('annule')
  annule,
}

/// Types de victoire
enum TypeVictoire {
  @JsonValue('points')
  points,
  @JsonValue('ecart_20')
  ecart20,
  @JsonValue('disqualification')
  disqualification,
  @JsonValue('abandon')
  abandon,
  @JsonValue('ko')
  ko,
  @JsonValue('decision_arbitre')
  decisionArbitre,
}

/// Données d'un round pour un combattant
@JsonSerializable()
class RoundData extends Equatable {
  @JsonKey(name: 'poing_tronc')
  final int poingTronc;
  @JsonKey(name: 'pied_tronc')
  final int piedTronc;
  @JsonKey(name: 'pied_rotatif_tronc')
  final int piedRotatifTronc;
  @JsonKey(name: 'pied_tete')
  final int piedTete;
  @JsonKey(name: 'pied_rotatif_tete')
  final int piedRotatifTete;
  final int kyonggo;
  final int gamjeom;

  const RoundData({
    this.poingTronc = 0,
    this.piedTronc = 0,
    this.piedRotatifTronc = 0,
    this.piedTete = 0,
    this.piedRotatifTete = 0,
    this.kyonggo = 0,
    this.gamjeom = 0,
  });

  /// Calcule le score des techniques (sans pénalités adversaire)
  int get scoreTechniques {
    return (poingTronc * 1) +
        (piedTronc * 2) +
        (piedRotatifTronc * 4) +
        (piedTete * 3) +
        (piedRotatifTete * 5);
  }

  factory RoundData.fromJson(Map<String, dynamic> json) =>
      _$RoundDataFromJson(json);

  Map<String, dynamic> toJson() => _$RoundDataToJson(this);

  RoundData copyWith({
    int? poingTronc,
    int? piedTronc,
    int? piedRotatifTronc,
    int? piedTete,
    int? piedRotatifTete,
    int? kyonggo,
    int? gamjeom,
  }) {
    return RoundData(
      poingTronc: poingTronc ?? this.poingTronc,
      piedTronc: piedTronc ?? this.piedTronc,
      piedRotatifTronc: piedRotatifTronc ?? this.piedRotatifTronc,
      piedTete: piedTete ?? this.piedTete,
      piedRotatifTete: piedRotatifTete ?? this.piedRotatifTete,
      kyonggo: kyonggo ?? this.kyonggo,
      gamjeom: gamjeom ?? this.gamjeom,
    );
  }

  @override
  List<Object?> get props => [
        poingTronc,
        piedTronc,
        piedRotatifTronc,
        piedTete,
        piedRotatifTete,
        kyonggo,
        gamjeom,
      ];
}

/// Données d'un round complet (rouge + bleu)
@JsonSerializable()
class RoundComplet extends Equatable {
  final RoundData rouge;
  final RoundData bleu;

  const RoundComplet({
    this.rouge = const RoundData(),
    this.bleu = const RoundData(),
  });

  factory RoundComplet.fromJson(Map<String, dynamic> json) =>
      _$RoundCompletFromJson(json);

  Map<String, dynamic> toJson() => _$RoundCompletToJson(this);

  @override
  List<Object?> get props => [rouge, bleu];
}

/// Modèle Combat Taekwondo
@JsonSerializable()
class CombatTaekwondoModel extends Equatable {
  final int id;
  @JsonKey(name: 'rencontre_id')
  final int rencontreId;
  @JsonKey(name: 'athlete_rouge_id')
  final int? athleteRougeId;
  @JsonKey(name: 'athlete_bleu_id')
  final int? athleteBleuId;
  @JsonKey(name: 'nom_rouge')
  final String nomRouge;
  @JsonKey(name: 'nom_bleu')
  final String nomBleu;
  final Map<String, RoundComplet>? rounds;
  @JsonKey(name: 'score_rouge')
  final int scoreRouge;
  @JsonKey(name: 'score_bleu')
  final int scoreBleu;
  final StatutCombat statut;
  final String? vainqueur;
  @JsonKey(name: 'type_victoire')
  final TypeVictoire? typeVictoire;
  @JsonKey(name: 'categorie_poids')
  final String? categoriePoids;
  @JsonKey(name: 'categorie_age')
  final String? categorieAge;
  @JsonKey(name: 'round_actuel')
  final int roundActuel;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const CombatTaekwondoModel({
    required this.id,
    required this.rencontreId,
    this.athleteRougeId,
    this.athleteBleuId,
    required this.nomRouge,
    required this.nomBleu,
    this.rounds,
    this.scoreRouge = 0,
    this.scoreBleu = 0,
    this.statut = StatutCombat.aVenir,
    this.vainqueur,
    this.typeVictoire,
    this.categoriePoids,
    this.categorieAge,
    this.roundActuel = 1,
    this.createdAt,
    this.updatedAt,
  });

  /// Vérifie si le combat est terminé
  bool get estTermine => statut == StatutCombat.termine;

  /// Vérifie si le combat est en cours
  bool get estEnCours => statut == StatutCombat.enCours;

  /// Vérifie si victoire par écart de 20 points
  bool get victoireParEcart => (scoreRouge - scoreBleu).abs() >= 20;

  /// Nom du vainqueur formaté
  String get vainqueurNom {
    if (vainqueur == 'rouge') return nomRouge;
    if (vainqueur == 'bleu') return nomBleu;
    return 'Non défini';
  }

  /// Label du type de victoire
  String get typeVictoireLabel {
    switch (typeVictoire) {
      case TypeVictoire.points:
        return 'Aux points';
      case TypeVictoire.ecart20:
        return 'Écart 20 pts';
      case TypeVictoire.disqualification:
        return 'Disqualification';
      case TypeVictoire.abandon:
        return 'Abandon';
      case TypeVictoire.ko:
        return 'KO';
      case TypeVictoire.decisionArbitre:
        return 'Décision arbitre';
      default:
        return '';
    }
  }

  /// Calcule le score total d'un combattant
  int calculerScore(String combattant) {
    if (rounds == null) return 0;
    
    int score = 0;
    for (var round in rounds!.values) {
      final data = combattant == 'rouge' ? round.rouge : round.bleu;
      final advData = combattant == 'rouge' ? round.bleu : round.rouge;
      
      score += data.scoreTechniques;
      score += (advData.kyonggo ~/ 2); // 2 kyonggo = 1 pt
      score += advData.gamjeom; // 1 gamjeom = 1 pt
    }
    return score;
  }

  factory CombatTaekwondoModel.fromJson(Map<String, dynamic> json) =>
      _$CombatTaekwondoModelFromJson(json);

  Map<String, dynamic> toJson() => _$CombatTaekwondoModelToJson(this);

  CombatTaekwondoModel copyWith({
    int? id,
    int? rencontreId,
    int? athleteRougeId,
    int? athleteBleuId,
    String? nomRouge,
    String? nomBleu,
    Map<String, RoundComplet>? rounds,
    int? scoreRouge,
    int? scoreBleu,
    StatutCombat? statut,
    String? vainqueur,
    TypeVictoire? typeVictoire,
    String? categoriePoids,
    String? categorieAge,
    int? roundActuel,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CombatTaekwondoModel(
      id: id ?? this.id,
      rencontreId: rencontreId ?? this.rencontreId,
      athleteRougeId: athleteRougeId ?? this.athleteRougeId,
      athleteBleuId: athleteBleuId ?? this.athleteBleuId,
      nomRouge: nomRouge ?? this.nomRouge,
      nomBleu: nomBleu ?? this.nomBleu,
      rounds: rounds ?? this.rounds,
      scoreRouge: scoreRouge ?? this.scoreRouge,
      scoreBleu: scoreBleu ?? this.scoreBleu,
      statut: statut ?? this.statut,
      vainqueur: vainqueur ?? this.vainqueur,
      typeVictoire: typeVictoire ?? this.typeVictoire,
      categoriePoids: categoriePoids ?? this.categoriePoids,
      categorieAge: categorieAge ?? this.categorieAge,
      roundActuel: roundActuel ?? this.roundActuel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        rencontreId,
        athleteRougeId,
        athleteBleuId,
        nomRouge,
        nomBleu,
        rounds,
        scoreRouge,
        scoreBleu,
        statut,
        vainqueur,
        typeVictoire,
        categoriePoids,
        categorieAge,
        roundActuel,
        createdAt,
        updatedAt,
      ];
}
