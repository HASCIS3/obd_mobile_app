import 'package:equatable/equatable.dart';

/// Classe de base pour les erreurs de l'application
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({
    required this.message,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}

/// Erreur serveur (5xx)
class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Erreur serveur. Veuillez réessayer plus tard.',
    super.statusCode,
  });
}

/// Erreur réseau (pas de connexion)
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Pas de connexion internet.',
    super.statusCode,
  });
}

/// Erreur d'authentification (401)
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    super.message = 'Session expirée. Veuillez vous reconnecter.',
    super.statusCode = 401,
  });
}

/// Erreur d'authentification générique
class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Identifiants incorrects.',
    super.statusCode,
  });
}

/// Erreur d'autorisation (403)
class AuthorizationFailure extends Failure {
  const AuthorizationFailure({
    super.message = 'Vous n\'avez pas les droits pour effectuer cette action.',
    super.statusCode = 403,
  });
}

/// Erreur ressource non trouvée (404)
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Ressource non trouvée.',
    super.statusCode = 404,
  });
}

/// Erreur de validation (422)
class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;

  const ValidationFailure({
    super.message = 'Données invalides.',
    super.statusCode = 422,
    this.errors,
  });

  @override
  List<Object?> get props => [message, statusCode, errors];
}

/// Erreur de cache
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Erreur de cache.',
  });
}

/// Erreur inconnue
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'Une erreur inattendue est survenue.',
    super.statusCode,
  });
}

/// Erreur de timeout
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'La requête a pris trop de temps.',
    super.statusCode,
  });
}
