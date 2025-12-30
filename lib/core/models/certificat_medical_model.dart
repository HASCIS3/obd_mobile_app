import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'certificat_medical_model.g.dart';

/// Modèle Certificat Médical
@JsonSerializable()
class CertificatMedicalModel extends Equatable {
  final int id;
  @JsonKey(name: 'athlete_id')
  final int athleteId;
  @JsonKey(name: 'athlete_nom')
  final String? athleteNom;
  final String? type;
  @JsonKey(name: 'date_emission')
  final DateTime dateEmission;
  @JsonKey(name: 'date_expiration')
  final DateTime dateExpiration;
  final String? medecin;
  final String? fichier;
  final String? remarques;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const CertificatMedicalModel({
    required this.id,
    required this.athleteId,
    this.athleteNom,
    this.type,
    required this.dateEmission,
    required this.dateExpiration,
    this.medecin,
    this.fichier,
    this.remarques,
    this.createdAt,
    this.updatedAt,
  });

  /// Vérifie si le certificat est valide
  bool get estValide => dateExpiration.isAfter(DateTime.now());

  /// Vérifie si le certificat expire bientôt (30 jours)
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
    if (!estValide) return 'Expiré';
    if (expireBientot) return 'Expire bientôt';
    return 'Valide';
  }

  factory CertificatMedicalModel.fromJson(Map<String, dynamic> json) =>
      _$CertificatMedicalModelFromJson(json);

  Map<String, dynamic> toJson() => _$CertificatMedicalModelToJson(this);

  CertificatMedicalModel copyWith({
    int? id,
    int? athleteId,
    String? athleteNom,
    String? type,
    DateTime? dateEmission,
    DateTime? dateExpiration,
    String? medecin,
    String? fichier,
    String? remarques,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CertificatMedicalModel(
      id: id ?? this.id,
      athleteId: athleteId ?? this.athleteId,
      athleteNom: athleteNom ?? this.athleteNom,
      type: type ?? this.type,
      dateEmission: dateEmission ?? this.dateEmission,
      dateExpiration: dateExpiration ?? this.dateExpiration,
      medecin: medecin ?? this.medecin,
      fichier: fichier ?? this.fichier,
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
        type,
        dateEmission,
        dateExpiration,
        medecin,
        fichier,
        remarques,
        createdAt,
        updatedAt,
      ];
}
