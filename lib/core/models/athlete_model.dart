import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'discipline_model.dart';

part 'athlete_model.g.dart';

/// Catégories d'âge
enum CategorieAge {
  poussin,
  benjamin,
  minime,
  cadet,
  junior,
  senior,
}

/// Modèle athlète
@JsonSerializable()
class AthleteModel extends Equatable {
  final int id;
  final String nom;
  final String prenom;
  @JsonKey(name: 'date_naissance')
  final DateTime? dateNaissance;
  final String sexe;
  final String? telephone;
  final String? email;
  final String? adresse;
  final String? photo;
  @JsonKey(name: 'nom_tuteur')
  final String? nomTuteur;
  @JsonKey(name: 'telephone_tuteur')
  final String? telephoneTuteur;
  @JsonKey(name: 'date_inscription')
  final DateTime? dateInscription;
  final bool actif;
  @JsonKey(name: 'bulletin_token')
  final String? bulletinToken;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  // Relations (optionnelles, chargées selon le contexte)
  final List<DisciplineModel>? disciplines;

  // Statistiques calculées (optionnelles)
  @JsonKey(name: 'taux_presence')
  final double? tauxPresence;
  final double? arrieres;

  const AthleteModel({
    required this.id,
    required this.nom,
    required this.prenom,
    this.dateNaissance,
    required this.sexe,
    this.telephone,
    this.email,
    this.adresse,
    this.photo,
    this.nomTuteur,
    this.telephoneTuteur,
    this.dateInscription,
    this.actif = true,
    this.bulletinToken,
    this.createdAt,
    this.updatedAt,
    this.disciplines,
    this.tauxPresence,
    this.arrieres,
  });

  /// Nom complet de l'athlète
  String get nomComplet => '$prenom $nom';

  /// Âge de l'athlète
  int? get age {
    if (dateNaissance == null) return null;
    final now = DateTime.now();
    int age = now.year - dateNaissance!.year;
    if (now.month < dateNaissance!.month ||
        (now.month == dateNaissance!.month && now.day < dateNaissance!.day)) {
      age--;
    }
    return age;
  }

  /// Catégorie d'âge
  CategorieAge? get categorieAge {
    final a = age;
    if (a == null) return null;
    if (a < 10) return CategorieAge.poussin;
    if (a < 13) return CategorieAge.benjamin;
    if (a < 15) return CategorieAge.minime;
    if (a < 18) return CategorieAge.cadet;
    if (a < 21) return CategorieAge.junior;
    return CategorieAge.senior;
  }

  /// Libellé de la catégorie d'âge
  String get categorieAgeLibelle {
    switch (categorieAge) {
      case CategorieAge.poussin:
        return 'Poussin';
      case CategorieAge.benjamin:
        return 'Benjamin';
      case CategorieAge.minime:
        return 'Minime';
      case CategorieAge.cadet:
        return 'Cadet';
      case CategorieAge.junior:
        return 'Junior';
      case CategorieAge.senior:
        return 'Senior';
      case null:
        return 'Non défini';
    }
  }

  /// Vérifie si l'athlète est mineur
  bool get estMineur => age != null && age! < 18;

  /// Vérifie si l'athlète est à jour de ses paiements
  bool get estAJourPaiements => (arrieres ?? 0) <= 0;

  /// Vérifie si l'athlète est éligible (pas d'arriérés importants)
  bool estEligible({double seuilArrieres = 50000}) =>
      (arrieres ?? 0) < seuilArrieres;

  /// URL complète de la photo
  String? get photoUrl => photo;

  /// Libellé du sexe
  String get sexeLibelle => sexe == 'M' ? 'Masculin' : 'Féminin';

  factory AthleteModel.fromJson(Map<String, dynamic> json) =>
      _$AthleteModelFromJson(json);

  Map<String, dynamic> toJson() => _$AthleteModelToJson(this);

  AthleteModel copyWith({
    int? id,
    String? nom,
    String? prenom,
    DateTime? dateNaissance,
    String? sexe,
    String? telephone,
    String? email,
    String? adresse,
    String? photo,
    String? nomTuteur,
    String? telephoneTuteur,
    DateTime? dateInscription,
    bool? actif,
    String? bulletinToken,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<DisciplineModel>? disciplines,
    double? tauxPresence,
    double? arrieres,
  }) {
    return AthleteModel(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      dateNaissance: dateNaissance ?? this.dateNaissance,
      sexe: sexe ?? this.sexe,
      telephone: telephone ?? this.telephone,
      email: email ?? this.email,
      adresse: adresse ?? this.adresse,
      photo: photo ?? this.photo,
      nomTuteur: nomTuteur ?? this.nomTuteur,
      telephoneTuteur: telephoneTuteur ?? this.telephoneTuteur,
      dateInscription: dateInscription ?? this.dateInscription,
      actif: actif ?? this.actif,
      bulletinToken: bulletinToken ?? this.bulletinToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      disciplines: disciplines ?? this.disciplines,
      tauxPresence: tauxPresence ?? this.tauxPresence,
      arrieres: arrieres ?? this.arrieres,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nom,
        prenom,
        dateNaissance,
        sexe,
        telephone,
        email,
        adresse,
        photo,
        nomTuteur,
        telephoneTuteur,
        dateInscription,
        actif,
        bulletinToken,
        createdAt,
        updatedAt,
        disciplines,
        tauxPresence,
        arrieres,
      ];
}
