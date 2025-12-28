import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/models/discipline_model.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../domain/repositories/discipline_repository.dart';
import '../datasources/discipline_remote_datasource.dart';

class DisciplineRepositoryImpl implements DisciplineRepository {
  final DisciplineRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  DisciplineRepositoryImpl({
    required DisciplineRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<DisciplineModel>>> getDisciplines() async {
    // Si connecté, récupérer depuis l'API
    if (await _networkInfo.isConnected) {
      try {
        final disciplines = await _remoteDataSource.getDisciplines();
        // Sauvegarder localement
        await _saveDisciplinesLocally(disciplines);
        return Right(disciplines);
      } on DioException catch (e) {
        return Left(_handleDioError(e));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    }

    // Mode hors-ligne
    debugPrint('Mode hors-ligne: chargement des disciplines depuis le cache local');
    try {
      final localData = LocalStorageService.getDisciplines();
      if (localData.isEmpty) {
        return const Left(CacheFailure(message: 'Aucune donnée locale disponible'));
      }
      final disciplines = localData.map((json) => DisciplineModel.fromJson(json)).toList();
      return Right(disciplines);
    } catch (e) {
      return Left(CacheFailure(message: 'Erreur lecture cache: $e'));
    }
  }

  Future<void> _saveDisciplinesLocally(List<DisciplineModel> disciplines) async {
    try {
      final jsonList = disciplines.map((d) => d.toJson()).toList();
      await LocalStorageService.saveDisciplines(jsonList);
    } catch (e) {
      debugPrint('Erreur sauvegarde locale disciplines: $e');
    }
  }

  @override
  Future<Either<Failure, DisciplineModel>> getDiscipline(int id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final discipline = await _remoteDataSource.getDiscipline(id);
      return Right(discipline);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Failure _handleDioError(DioException e) {
    final error = e.error;
    if (error is NetworkException) return const NetworkFailure();
    if (error is ServerException) return ServerFailure(message: error.message);
    return ServerFailure(message: e.message ?? 'Erreur inconnue');
  }
}
