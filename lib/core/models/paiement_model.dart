import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'athlete_model.dart';

part 'paiement_model.g.dart';

/// Statuts de paiement
enum StatutPaiement {
  @JsonValue('paye')
  paye,
  @JsonValue('impaye')
  impaye,
  @JsonValue('partiel')
  partiel,
}

/// Modes de paiement
enum ModePaiement {
  @JsonValue('especes')
  especes,
  @JsonValue('virement')
  virement,
  @JsonValue('mobile_money')
  mobileMoney,
}

/// Types de paiement
enum TypePaiement {
  @JsonValue('cotisation')
  cotisation,
  @JsonValue('inscription')
  inscription,
  @JsonValue('equipement')
  equipement,
}

/// Modèle paiement
@JsonSerializable()
class PaiementModel extends Equatable {
  final int id;
  @JsonKey(name: 'athlete_id')
  final int athleteId;
  @JsonKey(name: 'type_paiement')
  final TypePaiement typePaiement;
  @JsonKey(name: 'frais_inscription')
  final double? fraisInscription;
  @JsonKey(name: 'type_equipement')
  final String? typeEquipement;
  @JsonKey(name: 'frais_equipement')
  final double? fraisEquipement;
  final double montant;
  @JsonKey(name: 'montant_paye')
  final double montantPaye;
  final int mois;
  final int annee;
  @JsonKey(name: 'date_paiement')
  final DateTime? datePaiement;
  @JsonKey(name: 'mode_paiement')
  final ModePaiement? modePaiement;
  final StatutPaiement statut;
  final String? reference;
  final String? remarque;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  // Relation (optionnelle)
  final AthleteModel? athlete;

  const PaiementModel({
    required this.id,
    required this.athleteId,
    required this.typePaiement,
    this.fraisInscription,
    this.typeEquipement,
    this.fraisEquipement,
    required this.montant,
    this.montantPaye = 0,
    required this.mois,
    required this.annee,
    this.datePaiement,
    this.modePaiement,
    required this.statut,
    this.reference,
    this.remarque,
    this.createdAt,
    this.updatedAt,
    this.athlete,
  });

  /// Montant restant à payer
  double get resteAPayer => montant - montantPaye;

  /// Pourcentage payé
  double get pourcentagePaye =>
      montant > 0 ? (montantPaye / montant) * 100 : 0;

  /// Libellé de la période
  String get periode {
    const moisNoms = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    return '${moisNoms[mois - 1]} $annee';
  }

  /// Vérifie si le paiement est complet
  bool get estComplet => statut == StatutPaiement.paye;

  /// Vérifie si le paiement est en retard
  bool get estEnRetard {
    if (statut == StatutPaiement.paye) return false;
    final dateLimite = DateTime(annee, mois + 1, 0); // Dernier jour du mois
    return DateTime.now().isAfter(dateLimite);
  }

  /// Libellé du statut
  String get statutLibelle {
    switch (statut) {
      case StatutPaiement.paye:
        return 'Payé';
      case StatutPaiement.impaye:
        return 'Impayé';
      case StatutPaiement.partiel:
        return 'Partiel';
    }
  }

  /// Libellé du mode de paiement
  String? get modePaiementLibelle {
    switch (modePaiement) {
      case ModePaiement.especes:
        return 'Espèces';
      case ModePaiement.virement:
        return 'Virement bancaire';
      case ModePaiement.mobileMoney:
        return 'Mobile Money';
      case null:
        return null;
    }
  }

  /// Libellé du type de paiement
  String get typePaiementLibelle {
    switch (typePaiement) {
      case TypePaiement.cotisation:
        return 'Cotisation mensuelle';
      case TypePaiement.inscription:
        return 'Frais d\'inscription';
      case TypePaiement.equipement:
        return 'Équipement';
    }
  }

  /// Montant formaté
  String get montantFormate =>
      '${montant.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ')} FCFA';

  factory PaiementModel.fromJson(Map<String, dynamic> json) =>
      _$PaiementModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaiementModelToJson(this);

  PaiementModel copyWith({
    int? id,
    int? athleteId,
    TypePaiement? typePaiement,
    double? fraisInscription,
    String? typeEquipement,
    double? fraisEquipement,
    double? montant,
    double? montantPaye,
    int? mois,
    int? annee,
    DateTime? datePaiement,
    ModePaiement? modePaiement,
    StatutPaiement? statut,
    String? reference,
    String? remarque,
    DateTime? createdAt,
    DateTime? updatedAt,
    AthleteModel? athlete,
  }) {
    return PaiementModel(
      id: id ?? this.id,
      athleteId: athleteId ?? this.athleteId,
      typePaiement: typePaiement ?? this.typePaiement,
      fraisInscription: fraisInscription ?? this.fraisInscription,
      typeEquipement: typeEquipement ?? this.typeEquipement,
      fraisEquipement: fraisEquipement ?? this.fraisEquipement,
      montant: montant ?? this.montant,
      montantPaye: montantPaye ?? this.montantPaye,
      mois: mois ?? this.mois,
      annee: annee ?? this.annee,
      datePaiement: datePaiement ?? this.datePaiement,
      modePaiement: modePaiement ?? this.modePaiement,
      statut: statut ?? this.statut,
      reference: reference ?? this.reference,
      remarque: remarque ?? this.remarque,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      athlete: athlete ?? this.athlete,
    );
  }

  @override
  List<Object?> get props => [
        id,
        athleteId,
        typePaiement,
        fraisInscription,
        typeEquipement,
        fraisEquipement,
        montant,
        montantPaye,
        mois,
        annee,
        datePaiement,
        modePaiement,
        statut,
        reference,
        remarque,
        createdAt,
        updatedAt,
        athlete,
      ];
}
