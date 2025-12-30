// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combat_taekwondo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoundData _$RoundDataFromJson(Map<String, dynamic> json) => RoundData(
  poingTronc: (json['poing_tronc'] as num?)?.toInt() ?? 0,
  piedTronc: (json['pied_tronc'] as num?)?.toInt() ?? 0,
  piedRotatifTronc: (json['pied_rotatif_tronc'] as num?)?.toInt() ?? 0,
  piedTete: (json['pied_tete'] as num?)?.toInt() ?? 0,
  piedRotatifTete: (json['pied_rotatif_tete'] as num?)?.toInt() ?? 0,
  kyonggo: (json['kyonggo'] as num?)?.toInt() ?? 0,
  gamjeom: (json['gamjeom'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$RoundDataToJson(RoundData instance) => <String, dynamic>{
  'poing_tronc': instance.poingTronc,
  'pied_tronc': instance.piedTronc,
  'pied_rotatif_tronc': instance.piedRotatifTronc,
  'pied_tete': instance.piedTete,
  'pied_rotatif_tete': instance.piedRotatifTete,
  'kyonggo': instance.kyonggo,
  'gamjeom': instance.gamjeom,
};

RoundComplet _$RoundCompletFromJson(Map<String, dynamic> json) => RoundComplet(
  rouge: json['rouge'] == null
      ? const RoundData()
      : RoundData.fromJson(json['rouge'] as Map<String, dynamic>),
  bleu: json['bleu'] == null
      ? const RoundData()
      : RoundData.fromJson(json['bleu'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RoundCompletToJson(RoundComplet instance) =>
    <String, dynamic>{'rouge': instance.rouge, 'bleu': instance.bleu};

CombatTaekwondoModel _$CombatTaekwondoModelFromJson(
  Map<String, dynamic> json,
) => CombatTaekwondoModel(
  id: (json['id'] as num).toInt(),
  rencontreId: (json['rencontre_id'] as num).toInt(),
  athleteRougeId: (json['athlete_rouge_id'] as num?)?.toInt(),
  athleteBleuId: (json['athlete_bleu_id'] as num?)?.toInt(),
  nomRouge: json['nom_rouge'] as String,
  nomBleu: json['nom_bleu'] as String,
  rounds: (json['rounds'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, RoundComplet.fromJson(e as Map<String, dynamic>)),
  ),
  scoreRouge: (json['score_rouge'] as num?)?.toInt() ?? 0,
  scoreBleu: (json['score_bleu'] as num?)?.toInt() ?? 0,
  statut:
      $enumDecodeNullable(_$StatutCombatEnumMap, json['statut']) ??
      StatutCombat.aVenir,
  vainqueur: json['vainqueur'] as String?,
  typeVictoire: $enumDecodeNullable(
    _$TypeVictoireEnumMap,
    json['type_victoire'],
  ),
  categoriePoids: json['categorie_poids'] as String?,
  categorieAge: json['categorie_age'] as String?,
  roundActuel: (json['round_actuel'] as num?)?.toInt() ?? 1,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$CombatTaekwondoModelToJson(
  CombatTaekwondoModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'rencontre_id': instance.rencontreId,
  'athlete_rouge_id': instance.athleteRougeId,
  'athlete_bleu_id': instance.athleteBleuId,
  'nom_rouge': instance.nomRouge,
  'nom_bleu': instance.nomBleu,
  'rounds': instance.rounds,
  'score_rouge': instance.scoreRouge,
  'score_bleu': instance.scoreBleu,
  'statut': _$StatutCombatEnumMap[instance.statut]!,
  'vainqueur': instance.vainqueur,
  'type_victoire': _$TypeVictoireEnumMap[instance.typeVictoire],
  'categorie_poids': instance.categoriePoids,
  'categorie_age': instance.categorieAge,
  'round_actuel': instance.roundActuel,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

const _$StatutCombatEnumMap = {
  StatutCombat.aVenir: 'a_venir',
  StatutCombat.enCours: 'en_cours',
  StatutCombat.termine: 'termine',
  StatutCombat.annule: 'annule',
};

const _$TypeVictoireEnumMap = {
  TypeVictoire.points: 'points',
  TypeVictoire.ecart20: 'ecart_20',
  TypeVictoire.disqualification: 'disqualification',
  TypeVictoire.abandon: 'abandon',
  TypeVictoire.ko: 'ko',
  TypeVictoire.decisionArbitre: 'decision_arbitre',
};
