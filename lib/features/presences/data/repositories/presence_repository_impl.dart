import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/config/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/models/presence_model.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../domain/repositories/presence_repository.dart';
import '../datasources/presence_remote_datasource.dart';

class PresenceRepositoryImpl implements PresenceRepository {
  final PresenceRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  PresenceRepositoryImpl({
    required PresenceRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<PresenceModel>>> getPresences({
    int? athleteId,
    String? date,
  }) async {
    // Essayer de récupérer depuis l'API si connecté
    if (await _networkInfo.isConnected) {
      try {
        final presences = await _remoteDataSource.getPresences(
          athleteId: athleteId,
          date: date,
        );
        // Sauvegarder localement pour le mode hors-ligne
        await _savePresencesLocally(presences);
        return Right(presences);
      } on DioException catch (e) {
        // En cas d'erreur réseau, essayer le cache local
        debugPrint('Erreur API présences, tentative cache local: ${e.message}');
        return _getPresencesFromCache(athleteId: athleteId, date: date);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    }

    // Mode hors-ligne: récupérer depuis le stockage local
    debugPrint('Mode hors-ligne: chargement des présences depuis le cache local');
    return _getPresencesFromCache(athleteId: athleteId, date: date);
  }

  Either<Failure, List<PresenceModel>> _getPresencesFromCache({int? athleteId, String? date}) {
    try {
      final localData = LocalStorageService.getPresences();
      if (localData.isEmpty) {
        return const Right([]); // Retourner liste vide au lieu d'erreur
      }
      var presences = localData.map((json) => PresenceModel.fromJson(json)).toList();
      
      // Filtrer si nécessaire
      if (athleteId != null) {
        presences = presences.where((p) => p.athleteId == athleteId).toList();
      }
      if (date != null) {
        presences = presences.where((p) => p.date.toIso8601String().startsWith(date)).toList();
      }
      
      return Right(presences);
    } catch (e) {
      return Left(CacheFailure(message: 'Erreur lecture cache: $e'));
    }
  }

  Future<void> _savePresencesLocally(List<PresenceModel> presences) async {
    try {
      final jsonList = presences.map((p) => p.toJson()).toList();
      await LocalStorageService.savePresences(jsonList);
    } catch (e) {
      debugPrint('Erreur sauvegarde locale présences: $e');
    }
  }

  @override
  Future<Either<Failure, PresenceModel>> createPresence(
      Map<String, dynamic> data) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final presence = await _remoteDataSource.createPresence(data);
      return Right(presence);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PresenceModel>> updatePresence(
      int id, Map<String, dynamic> data) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final presence = await _remoteDataSource.updatePresence(id, data);
      return Right(presence);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePresence(int id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDataSource.deletePresence(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> pointageMasse(
      List<Map<String, dynamic>> presences) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDataSource.pointageMasse(presences);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Failure _handleDioError(DioException e) {
    final error = e.error;
    if (error is ValidationException) {
      return ValidationFailure(message: error.message, errors: error.errors);
    }
    if (error is NetworkException) return const NetworkFailure();
    if (error is ServerException) return ServerFailure(message: error.message);
    return ServerFailure(message: e.message ?? 'Erreur inconnue');
  }
}
