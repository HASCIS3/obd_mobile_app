import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/models/presence_model.dart';
import '../../../../core/network/network_info.dart';
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
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final presences = await _remoteDataSource.getPresences(
        athleteId: athleteId,
        date: date,
      );
      return Right(presences);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
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
