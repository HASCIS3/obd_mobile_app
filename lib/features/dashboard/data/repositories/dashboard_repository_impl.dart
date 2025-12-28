import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';
import '../models/dashboard_stats_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  DashboardRepositoryImpl({
    required DashboardRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, DashboardResponse>> getDashboard() async {
    // Si connecté, récupérer depuis l'API
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.getDashboard();
        // Sauvegarder localement pour le mode hors-ligne
        await _saveDashboardLocally(response);
        return Right(response);
      } on DioException catch (e) {
        // En cas d'erreur réseau, essayer le cache local
        debugPrint('Erreur API dashboard, tentative cache local: ${e.message}');
        return _getDashboardFromCache();
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    }

    // Mode hors-ligne: récupérer depuis le cache local
    debugPrint('Mode hors-ligne: chargement du dashboard depuis le cache local');
    return _getDashboardFromCache();
  }

  Either<Failure, DashboardResponse> _getDashboardFromCache() {
    try {
      final localData = LocalStorageService.getDashboard();
      if (localData == null) {
        // Retourner des stats vides au lieu d'une erreur
        return Right(DashboardResponse(
          stats: DashboardStatsModel(
            athletesActifs: 0,
            athletesTotal: 0,
            disciplines: 0,
            presencesJour: 0,
            paiements: const PaiementStats(total: 0, paye: 0, arrieres: 0),
          ),
          activitesRecentes: [],
          user: const DashboardUser(name: 'Utilisateur', role: 'coach'),
        ));
      }
      final response = DashboardResponse.fromJson(localData);
      return Right(response);
    } catch (e) {
      return Left(CacheFailure(message: 'Erreur lecture cache: $e'));
    }
  }

  Future<void> _saveDashboardLocally(DashboardResponse response) async {
    try {
      await LocalStorageService.saveDashboard(response.toJson());
    } catch (e) {
      debugPrint('Erreur sauvegarde locale dashboard: $e');
    }
  }

  Failure _handleDioError(DioException e) {
    final error = e.error;

    if (error is AuthenticationException) {
      return AuthFailure(message: error.message);
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
