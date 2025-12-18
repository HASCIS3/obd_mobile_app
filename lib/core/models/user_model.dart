import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/// Rôles utilisateur
enum UserRole {
  @JsonValue('admin')
  admin,
  @JsonValue('coach')
  coach,
}

/// Modèle utilisateur
@JsonSerializable()
class UserModel extends Equatable {
  final int id;
  @JsonKey(name: 'athlete_id')
  final int? athleteId;
  final String name;
  final String email;
  final UserRole? role;
  final String? photo;
  @JsonKey(name: 'email_verified_at')
  final DateTime? emailVerifiedAt;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    this.athleteId,
    required this.name,
    required this.email,
    this.role,
    this.photo,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  /// Vérifie si l'utilisateur est admin
  bool get isAdmin => role == UserRole.admin;

  /// Vérifie si l'utilisateur est coach
  bool get isCoach => role == UserRole.coach && athleteId == null;

  /// Vérifie si l'utilisateur est un athlète
  bool get isAthlete => athleteId != null;

  /// URL complète de la photo
  String? get photoUrl => photo;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    int? id,
    int? athleteId,
    String? name,
    String? email,
    UserRole? role,
    String? photo,
    DateTime? emailVerifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      athleteId: athleteId ?? this.athleteId,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      photo: photo ?? this.photo,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        athleteId,
        name,
        email,
        role,
        photo,
        emailVerifiedAt,
        createdAt,
        updatedAt,
      ];
}
