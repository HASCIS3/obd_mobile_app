import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/config/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/models/athlete_model.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../domain/repositories/athlete_repository.dart';
import '../datasources/athlete_remote_datasource.dart';

class AthleteRepositoryImpl implements AthleteRepository {
  final AthleteRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  AthleteRepositoryImpl({
    required AthleteRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<AthleteModel>>> getAthletes({
    String? search,
    bool? actif,
  }) async {
    // Essayer de récupérer depuis l'API si connecté
    if (await _networkInfo.isConnected) {
      try {
        final athletes = await _remoteDataSource.getAthletes(
          search: search,
          actif: actif,
        );
        // Sauvegarder localement pour le mode hors-ligne
        await _saveAthletesLocally(athletes);
        return Right(athletes);
      } on DioException catch (e) {
        // En cas d'erreur réseau, essayer le cache local
        debugPrint('Erreur API athlètes, tentative cache local: ${e.message}');
        return _getAthletesFromCache(search: search, actif: actif);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    }

    // Mode hors-ligne: récupérer depuis le stockage local
    debugPrint('Mode hors-ligne: chargement des athlètes depuis le cache local');
    return _getAthletesFromCache(search: search, actif: actif);
  }

  Either<Failure, List<AthleteModel>> _getAthletesFromCache({String? search, bool? actif}) {
    try {
      final localData = LocalStorageService.getAthletes();
      if (localData.isEmpty) {
        return const Right([]); // Retourner liste vide au lieu d'erreur
      }
      var athletes = localData.map((json) => AthleteModel.fromJson(json)).toList();
      
      // Filtrer si nécessaire
      if (search != null && search.isNotEmpty) {
        athletes = athletes.where((a) => 
          a.nomComplet.toLowerCase().contains(search.toLowerCase())
        ).toList();
      }
      if (actif != null) {
        athletes = athletes.where((a) => a.actif == actif).toList();
      }
      
      return Right(athletes);
    } catch (e) {
      return Left(CacheFailure(message: 'Erreur lecture cache: $e'));
    }
  }

  Future<void> _saveAthletesLocally(List<AthleteModel> athletes) async {
    try {
      final jsonList = athletes.map((a) => a.toJson()).toList();
      await LocalStorageService.saveAthletes(jsonList);
    } catch (e) {
      debugPrint('Erreur sauvegarde locale athlètes: $e');
    }
  }

  @override
  Future<Either<Failure, AthleteModel>> getAthlete(int id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final athlete = await _remoteDataSource.getAthlete(id);
      return Right(athlete);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AthleteModel>> createAthlete(
      Map<String, dynamic> data) async {
    // Si connecté, envoyer directement à l'API
    if (await _networkInfo.isConnected) {
      try {
        final athlete = await _remoteDataSource.createAthlete(data);
        // Mettre à jour le cache local
        await LocalStorageService.saveAthlete(athlete.toJson());
        return Right(athlete);
      } on DioException catch (e) {
        return Left(_handleDioError(e));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    }

    // Mode hors-ligne: sauvegarder localement et ajouter à la file de synchronisation
    debugPrint('Mode hors-ligne: sauvegarde locale de l\'athlète pour synchronisation ultérieure');
    try {
      // Créer un ID temporaire négatif pour les données locales
      final tempId = -DateTime.now().millisecondsSinceEpoch;
      data['id'] = tempId;
      data['_pending_sync'] = true;
      
      // Sauvegarder localement
      await LocalStorageService.saveAthlete(data);
      
      // Ajouter à la file de synchronisation
      await LocalStorageService.addPendingSync({
        'type': 'POST',
        'endpoint': ApiEndpoints.athletes,
        'data': data,
        'entity': 'athlete',
      });
      
      // Retourner un modèle temporaire
      final tempAthlete = AthleteModel.fromJson(data);
      return Right(tempAthlete);
    } catch (e) {
      return Left(CacheFailure(message: 'Erreur sauvegarde locale: $e'));
    }
  }

  @override
  Future<Either<Failure, AthleteModel>> updateAthlete(
      int id, Map<String, dynamic> data) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final athlete = await _remoteDataSource.updateAthlete(id, data);
      return Right(athlete);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAthlete(int id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDataSource.deleteAthlete(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Failure _handleDioError(DioException e) {
    final error = e.error;

    if (error is AuthenticationException) {
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

    return ServerFailure(message: e.message ?? 'Erreur inconnue');
  }
}
