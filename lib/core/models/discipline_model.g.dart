// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discipline_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DisciplineModel _$DisciplineModelFromJson(Map<String, dynamic> json) =>
    DisciplineModel(
      id: (json['id'] as num).toInt(),
      nom: json['nom'] as String,
      description: json['description'] as String?,
      tarifMensuel: (json['tarif_mensuel'] as num).toDouble(),
      actif: json['actif'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      nbAthletesActifs: (json['nb_athletes_actifs'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DisciplineModelToJson(DisciplineModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
      'description': instance.description,
      'tarif_mensuel': instance.tarifMensuel,
      'actif': instance.actif,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'nb_athletes_actifs': instance.nbAthletesActifs,
    };
