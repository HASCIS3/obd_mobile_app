// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paiement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaiementModel _$PaiementModelFromJson(Map<String, dynamic> json) =>
    PaiementModel(
      id: (json['id'] as num).toInt(),
      athleteId: (json['athlete_id'] as num).toInt(),
      typePaiement: $enumDecode(_$TypePaiementEnumMap, json['type_paiement']),
      fraisInscription: (json['frais_inscription'] as num?)?.toDouble(),
      typeEquipement: json['type_equipement'] as String?,
      fraisEquipement: (json['frais_equipement'] as num?)?.toDouble(),
      montant: (json['montant'] as num).toDouble(),
      montantPaye: (json['montant_paye'] as num?)?.toDouble() ?? 0,
      mois: (json['mois'] as num).toInt(),
      annee: (json['annee'] as num).toInt(),
      datePaiement: json['date_paiement'] == null
          ? null
          : DateTime.parse(json['date_paiement'] as String),
      modePaiement: $enumDecodeNullable(
        _$ModePaiementEnumMap,
        json['mode_paiement'],
      ),
      statut: $enumDecode(_$StatutPaiementEnumMap, json['statut']),
      reference: json['reference'] as String?,
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
    );

Map<String, dynamic> _$PaiementModelToJson(PaiementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'athlete_id': instance.athleteId,
      'type_paiement': _$TypePaiementEnumMap[instance.typePaiement]!,
      'frais_inscription': instance.fraisInscription,
      'type_equipement': instance.typeEquipement,
      'frais_equipement': instance.fraisEquipement,
      'montant': instance.montant,
      'montant_paye': instance.montantPaye,
      'mois': instance.mois,
      'annee': instance.annee,
      'date_paiement': instance.datePaiement?.toIso8601String(),
      'mode_paiement': _$ModePaiementEnumMap[instance.modePaiement],
      'statut': _$StatutPaiementEnumMap[instance.statut]!,
      'reference': instance.reference,
      'remarque': instance.remarque,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'athlete': instance.athlete,
    };

const _$TypePaiementEnumMap = {
  TypePaiement.cotisation: 'cotisation',
  TypePaiement.inscription: 'inscription',
  TypePaiement.equipement: 'equipement',
};

const _$ModePaiementEnumMap = {
  ModePaiement.especes: 'especes',
  ModePaiement.virement: 'virement',
  ModePaiement.mobileMoney: 'mobile_money',
};

const _$StatutPaiementEnumMap = {
  StatutPaiement.paye: 'paye',
  StatutPaiement.impaye: 'impaye',
  StatutPaiement.partiel: 'partiel',
};
