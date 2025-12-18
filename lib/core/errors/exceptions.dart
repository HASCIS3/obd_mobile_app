/// Exception de base pour l'application
class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const AppException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'AppException: $message (code: $statusCode)';
}

/// Exception serveur
class ServerException extends AppException {
  const ServerException({
    super.message = 'Erreur serveur',
    super.statusCode,
    super.data,
  });
}

/// Exception réseau
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Pas de connexion internet',
    super.statusCode,
    super.data,
  });
}

/// Exception d'authentification
class AuthenticationException extends AppException {
  const AuthenticationException({
    super.message = 'Non authentifié',
    super.statusCode = 401,
    super.data,
  });
}

/// Exception d'autorisation
class AuthorizationException extends AppException {
  const AuthorizationException({
    super.message = 'Non autorisé',
    super.statusCode = 403,
    super.data,
  });
}

/// Exception ressource non trouvée
class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Ressource non trouvée',
    super.statusCode = 404,
    super.data,
  });
}

/// Exception de validation
class ValidationException extends AppException {
  final Map<String, List<String>>? errors;

  const ValidationException({
    super.message = 'Données invalides',
    super.statusCode = 422,
    super.data,
    this.errors,
  });
}

/// Exception de cache
class CacheException extends AppException {
  const CacheException({
    super.message = 'Erreur de cache',
    super.statusCode,
    super.data,
  });
}

/// Exception de timeout
class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Timeout',
    super.statusCode,
    super.data,
  });
}
