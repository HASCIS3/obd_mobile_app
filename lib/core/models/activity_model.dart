import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activity_model.g.dart';

/// Types d'activité
enum TypeActivity {
  @JsonValue('stage')
  stage,
  @JsonValue('competition')
  competition,
  @JsonValue('evenement')
  evenement,
  @JsonValue('reunion')
  reunion,
  @JsonValue('entrainement')
  entrainement,
  @JsonValue('autre')
  autre,
}

/// Statut de l'activité
enum StatutActivity {
  @JsonValue('planifie')
  planifie,
  @JsonValue('en_cours')
  enCours,
  @JsonValue('termine')
  termine,
  @JsonValue('annule')
  annule,
}

/// Modèle Activity
@JsonSerializable()
class ActivityModel extends Equatable {
  final int id;
  final String titre;
  final String? description;
  final TypeActivity? type;
  final DateTime debut;
  final DateTime? fin;
  final String? lieu;
  final String? image;
  final StatutActivity? statut;
  @JsonKey(name: 'discipline_id')
  final int? disciplineId;
  @JsonKey(name: 'discipline_nom')
  final String? disciplineNom;
  @JsonKey(name: 'nb_participants')
  final int? nbParticipants;
  @JsonKey(name: 'max_participants')
  final int? maxParticipants;
  final double? tarif;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const ActivityModel({
    required this.id,
    required this.titre,
    this.description,
    this.type,
    required this.debut,
    this.fin,
    this.lieu,
    this.image,
    this.statut,
    this.disciplineId,
    this.disciplineNom,
    this.nbParticipants,
    this.maxParticipants,
    this.tarif,
    this.createdAt,
    this.updatedAt,
  });

  /// Vérifie si l'activité est à venir
  bool get estAVenir => debut.isAfter(DateTime.now());

  /// Vérifie si l'activité est en cours
  bool get estEnCours {
    final now = DateTime.now();
    return debut.isBefore(now) && (fin == null || fin!.isAfter(now));
  }

  /// Vérifie si l'activité est terminée
  bool get estTerminee => fin != null && fin!.isBefore(DateTime.now());

  /// Places restantes
  int? get placesRestantes {
    if (maxParticipants == null) return null;
    return maxParticipants! - (nbParticipants ?? 0);
  }

  /// Vérifie si l'activité est complète
  bool get estComplete {
    if (maxParticipants == null) return false;
    return (nbParticipants ?? 0) >= maxParticipants!;
  }

  /// Label du type d'activité
  String get typeLabel {
    switch (type) {
      case TypeActivity.stage:
        return 'Stage';
      case TypeActivity.competition:
        return 'Compétition';
      case TypeActivity.evenement:
        return 'Événement';
      case TypeActivity.reunion:
        return 'Réunion';
      case TypeActivity.entrainement:
        return 'Entraînement';
      case TypeActivity.autre:
        return 'Autre';
      default:
        return 'Activité';
    }
  }

  /// Label du statut
  String get statutLabel {
    switch (statut) {
      case StatutActivity.planifie:
        return 'Planifié';
      case StatutActivity.enCours:
        return 'En cours';
      case StatutActivity.termine:
        return 'Terminé';
      case StatutActivity.annule:
        return 'Annulé';
      default:
        return 'Non défini';
    }
  }

  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityModelToJson(this);

  ActivityModel copyWith({
    int? id,
    String? titre,
    String? description,
    TypeActivity? type,
    DateTime? debut,
    DateTime? fin,
    String? lieu,
    String? image,
    StatutActivity? statut,
    int? disciplineId,
    String? disciplineNom,
    int? nbParticipants,
    int? maxParticipants,
    double? tarif,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      titre: titre ?? this.titre,
      description: description ?? this.description,
      type: type ?? this.type,
      debut: debut ?? this.debut,
      fin: fin ?? this.fin,
      lieu: lieu ?? this.lieu,
      image: image ?? this.image,
      statut: statut ?? this.statut,
      disciplineId: disciplineId ?? this.disciplineId,
      disciplineNom: disciplineNom ?? this.disciplineNom,
      nbParticipants: nbParticipants ?? this.nbParticipants,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      tarif: tarif ?? this.tarif,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        titre,
        description,
        type,
        debut,
        fin,
        lieu,
        image,
        statut,
        disciplineId,
        disciplineNom,
        nbParticipants,
        maxParticipants,
        tarif,
        createdAt,
        updatedAt,
      ];
}

/// Stats des activités pour le dashboard
@JsonSerializable()
class ActivityStats extends Equatable {
  final int total;
  @JsonKey(name: 'a_venir')
  final int aVenir;
  @JsonKey(name: 'en_cours')
  final int enCours;
  final int terminees;

  const ActivityStats({
    this.total = 0,
    this.aVenir = 0,
    this.enCours = 0,
    this.terminees = 0,
  });

  factory ActivityStats.fromJson(Map<String, dynamic> json) =>
      _$ActivityStatsFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityStatsToJson(this);

  @override
  List<Object?> get props => [total, aVenir, enCours, terminees];
}
