import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implémentation du repository d'authentification
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, UserModel>> login(String email, String password) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _remoteDataSource.login(email, password);
      
      // Sauvegarder le token et l'utilisateur localement
      await _localDataSource.saveToken(response.token);
      await _localDataSource.saveUser(response.user);
      
      return Right(response.user);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      if (await _networkInfo.isConnected) {
        await _remoteDataSource.logout();
      }
    } catch (_) {
      // Ignorer les erreurs de logout côté serveur
    }
    
    // Toujours nettoyer le stockage local
    await _localDataSource.clearAll();
    return const Right(null);
  }

  @override
  Future<Either<Failure, UserModel>> getCurrentUser() async {
    // D'abord essayer de récupérer l'utilisateur local
    final localUser = await _localDataSource.getUser();
    
    if (!await _networkInfo.isConnected) {
      if (localUser != null) {
        return Right(localUser);
      }
      return const Left(NetworkFailure());
    }

    try {
      final user = await _remoteDataSource.getCurrentUser();
      await _localDataSource.saveUser(user);
      return Right(user);
    } on DioException catch (e) {
      if (localUser != null) {
        return Right(localUser);
      }
      return Left(_handleDioError(e));
    } catch (e) {
      if (localUser != null) {
        return Right(localUser);
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDataSource.forgotPassword(email);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _localDataSource.getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<String?> getToken() async {
    return await _localDataSource.getToken();
  }

  @override
  Future<UserModel?> getCachedUser() async {
    return await _localDataSource.getUser();
  }

  Failure _handleDioError(DioException e) {
    final error = e.error;
    
    if (error is AuthenticationException) {
      return AuthFailure(message: error.message);
    }
    if (error is AuthorizationException) {
      return AuthFailure(message: error.message);
    }
    if (error is ValidationException) {
      return ValidationFailure(
        message: error.message,
        errors: error.errors,
      );
    }
    if (error is NetworkException) {
      return const NetworkFailure();
    }
    if (error is ServerException) {
      return ServerFailure(message: error.message);
    }
    if (error is TimeoutException) {
      return const NetworkFailure(message: 'Délai de connexion dépassé');
    }
    
    return ServerFailure(message: e.message ?? 'Erreur inconnue');
  }
}
