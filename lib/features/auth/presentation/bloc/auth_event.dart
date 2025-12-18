part of 'auth_bloc.dart';

/// Événements d'authentification
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Vérifier l'état d'authentification au démarrage
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Demande de connexion
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Demande de déconnexion
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Demande de réinitialisation du mot de passe
class AuthForgotPasswordRequested extends AuthEvent {
  final String email;

  const AuthForgotPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Réinitialiser l'état après une erreur
class AuthErrorCleared extends AuthEvent {
  const AuthErrorCleared();
}
