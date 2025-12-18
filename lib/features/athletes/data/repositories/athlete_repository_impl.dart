import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/models/athlete_model.dart';
import '../../../../core/network/network_info.dart';
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
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final athletes = await _remoteDataSource.getAthletes(
        search: search,
        actif: actif,
      );
      return Right(athletes);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
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
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final athlete = await _remoteDataSource.createAthlete(data);
      return Right(athlete);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
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
