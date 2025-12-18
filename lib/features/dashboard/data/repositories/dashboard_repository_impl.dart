import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
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
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _remoteDataSource.getDashboard();
      return Right(response);
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
    if (error is NetworkException) {
      return const NetworkFailure();
    }
    if (error is ServerException) {
      return ServerFailure(message: error.message);
    }

    return ServerFailure(message: e.message ?? 'Erreur inconnue');
  }
}
