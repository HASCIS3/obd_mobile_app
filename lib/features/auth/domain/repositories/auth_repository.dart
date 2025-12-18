import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/models/user_model.dart';

/// Interface du repository d'authentification
abstract class AuthRepository {
  /// Connexion avec email et mot de passe
  Future<Either<Failure, UserModel>> login(String email, String password);
  
  /// Déconnexion
  Future<Either<Failure, void>> logout();
  
  /// Récupérer l'utilisateur courant
  Future<Either<Failure, UserModel>> getCurrentUser();
  
  /// Demander la réinitialisation du mot de passe
  Future<Either<Failure, void>> forgotPassword(String email);
  
  /// Vérifier si l'utilisateur est authentifié
  Future<bool> isAuthenticated();
  
  /// Récupérer le token stocké
  Future<String?> getToken();
  
  /// Récupérer l'utilisateur en cache
  Future<UserModel?> getCachedUser();
}
