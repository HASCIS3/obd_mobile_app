import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/models/performance_model.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/performance_repository.dart';
import '../datasources/performance_remote_datasource.dart';

class PerformanceRepositoryImpl implements PerformanceRepository {
  final PerformanceRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  PerformanceRepositoryImpl({
    required PerformanceRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<PerformanceModel>>> getPerformances({
    int? athleteId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final performances = await _remoteDataSource.getPerformances(athleteId: athleteId);
      return Right(performances);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PerformanceModel>> createPerformance(
      Map<String, dynamic> data) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final performance = await _remoteDataSource.createPerformance(data);
      return Right(performance);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PerformanceModel>> updatePerformance(
      int id, Map<String, dynamic> data) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final performance = await _remoteDataSource.updatePerformance(id, data);
      return Right(performance);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePerformance(int id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDataSource.deletePerformance(id);
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
