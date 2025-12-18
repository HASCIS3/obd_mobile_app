import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'discipline_model.g.dart';

/// Modèle discipline
@JsonSerializable()
class DisciplineModel extends Equatable {
  final int id;
  final String nom;
  final String? description;
  @JsonKey(name: 'tarif_mensuel')
  final double tarifMensuel;
  final bool actif;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  // Statistiques (optionnelles)
  @JsonKey(name: 'nb_athletes_actifs')
  final int? nbAthletesActifs;

  const DisciplineModel({
    required this.id,
    required this.nom,
    this.description,
    required this.tarifMensuel,
    this.actif = true,
    this.createdAt,
    this.updatedAt,
    this.nbAthletesActifs,
  });

  /// Tarif formaté
  String get tarifFormate =>
      '${tarifMensuel.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ')} FCFA';

  factory DisciplineModel.fromJson(Map<String, dynamic> json) =>
      _$DisciplineModelFromJson(json);

  Map<String, dynamic> toJson() => _$DisciplineModelToJson(this);

  DisciplineModel copyWith({
    int? id,
    String? nom,
    String? description,
    double? tarifMensuel,
    bool? actif,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? nbAthletesActifs,
  }) {
    return DisciplineModel(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      description: description ?? this.description,
      tarifMensuel: tarifMensuel ?? this.tarifMensuel,
      actif: actif ?? this.actif,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      nbAthletesActifs: nbAthletesActifs ?? this.nbAthletesActifs,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nom,
        description,
        tarifMensuel,
        actif,
        createdAt,
        updatedAt,
        nbAthletesActifs,
      ];
}
