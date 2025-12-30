import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'licence_model.g.dart';

/// Statut de la licence
enum StatutLicence {
  @JsonValue('valide')
  valide,
  @JsonValue('expirant')
  expirant,
  @JsonValue('expiree')
  expiree,
  @JsonValue('en_attente')
  enAttente,
}

/// Modèle Licence
@JsonSerializable()
class LicenceModel extends Equatable {
  final int id;
  @JsonKey(name: 'athlete_id')
  final int athleteId;
  @JsonKey(name: 'athlete_nom')
  final String? athleteNom;
  final String numero;
  final String? type;
  @JsonKey(name: 'date_emission')
  final DateTime dateEmission;
  @JsonKey(name: 'date_expiration')
  final DateTime dateExpiration;
  final StatutLicence? statut;
  @JsonKey(name: 'federation')
  final String? federation;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const LicenceModel({
    required this.id,
    required this.athleteId,
    this.athleteNom,
    required this.numero,
    this.type,
    required this.dateEmission,
    required this.dateExpiration,
    this.statut,
    this.federation,
    this.createdAt,
    this.updatedAt,
  });

  /// Vérifie si la licence est valide
  bool get estValide => dateExpiration.isAfter(DateTime.now());

  /// Vérifie si la licence expire bientôt (30 jours)
  bool get expireBientot {
    final diff = dateExpiration.difference(DateTime.now()).inDays;
    return diff > 0 && diff <= 30;
  }

  /// Jours restants avant expiration
  int get joursRestants {
    final diff = dateExpiration.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }

  /// Label du statut
  String get statutLabel {
    if (!estValide) return 'Expirée';
    if (expireBientot) return 'Expire bientôt';
    return 'Valide';
  }

  factory LicenceModel.fromJson(Map<String, dynamic> json) =>
      _$LicenceModelFromJson(json);

  Map<String, dynamic> toJson() => _$LicenceModelToJson(this);

  LicenceModel copyWith({
    int? id,
    int? athleteId,
    String? athleteNom,
    String? numero,
    String? type,
    DateTime? dateEmission,
    DateTime? dateExpiration,
    StatutLicence? statut,
    String? federation,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LicenceModel(
      id: id ?? this.id,
      athleteId: athleteId ?? this.athleteId,
      athleteNom: athleteNom ?? this.athleteNom,
      numero: numero ?? this.numero,
      type: type ?? this.type,
      dateEmission: dateEmission ?? this.dateEmission,
      dateExpiration: dateExpiration ?? this.dateExpiration,
      statut: statut ?? this.statut,
      federation: federation ?? this.federation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        athleteId,
        athleteNom,
        numero,
        type,
        dateEmission,
        dateExpiration,
        statut,
        federation,
        createdAt,
        updatedAt,
      ];
}
