import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/models/paiement_model.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/paiement_repository.dart';
import '../datasources/paiement_remote_datasource.dart';

class PaiementRepositoryImpl implements PaiementRepository {
  final PaiementRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  PaiementRepositoryImpl({
    required PaiementRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<PaiementModel>>> getPaiements({
    int? athleteId,
    String? mois,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final paiements = await _remoteDataSource.getPaiements(
        athleteId: athleteId,
        mois: mois,
      );
      return Right(paiements);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaiementModel>> getPaiement(int id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final paiement = await _remoteDataSource.getPaiement(id);
      return Right(paiement);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaiementModel>> createPaiement(
      Map<String, dynamic> data) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final paiement = await _remoteDataSource.createPaiement(data);
      return Right(paiement);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaiementModel>> updatePaiement(
      int id, Map<String, dynamic> data) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final paiement = await _remoteDataSource.updatePaiement(id, data);
      return Right(paiement);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePaiement(int id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDataSource.deletePaiement(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PaiementModel>>> getArrieres() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final arrieres = await _remoteDataSource.getArrieres();
      return Right(arrieres);
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
