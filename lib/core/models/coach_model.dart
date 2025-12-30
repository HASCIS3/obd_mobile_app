import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coach_model.g.dart';

/// Modèle Coach
@JsonSerializable()
class CoachModel extends Equatable {
  final int id;
  @JsonKey(name: 'user_id')
  final int? userId;
  final String nom;
  final String prenom;
  final String? telephone;
  final String? email;
  final String? specialite;
  final String? photo;
  final String? statut;
  @JsonKey(name: 'date_embauche')
  final DateTime? dateEmbauche;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const CoachModel({
    required this.id,
    this.userId,
    required this.nom,
    required this.prenom,
    this.telephone,
    this.email,
    this.specialite,
    this.photo,
    this.statut,
    this.dateEmbauche,
    this.createdAt,
    this.updatedAt,
  });

  /// Nom complet
  String get nomComplet => '$prenom $nom';

  /// Initiales
  String get initiales {
    final p = prenom.isNotEmpty ? prenom[0].toUpperCase() : '';
    final n = nom.isNotEmpty ? nom[0].toUpperCase() : '';
    return '$p$n';
  }

  /// Vérifie si le coach est actif
  bool get estActif => statut == 'actif';

  factory CoachModel.fromJson(Map<String, dynamic> json) =>
      _$CoachModelFromJson(json);

  Map<String, dynamic> toJson() => _$CoachModelToJson(this);

  CoachModel copyWith({
    int? id,
    int? userId,
    String? nom,
    String? prenom,
    String? telephone,
    String? email,
    String? specialite,
    String? photo,
    String? statut,
    DateTime? dateEmbauche,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CoachModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      telephone: telephone ?? this.telephone,
      email: email ?? this.email,
      specialite: specialite ?? this.specialite,
      photo: photo ?? this.photo,
      statut: statut ?? this.statut,
      dateEmbauche: dateEmbauche ?? this.dateEmbauche,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        nom,
        prenom,
        telephone,
        email,
        specialite,
        photo,
        statut,
        dateEmbauche,
        createdAt,
        updatedAt,
      ];
}
