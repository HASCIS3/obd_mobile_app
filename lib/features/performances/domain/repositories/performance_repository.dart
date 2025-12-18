import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/models/performance_model.dart';

abstract class PerformanceRepository {
  Future<Either<Failure, List<PerformanceModel>>> getPerformances({int? athleteId});
  Future<Either<Failure, PerformanceModel>> createPerformance(Map<String, dynamic> data);
  Future<Either<Failure, PerformanceModel>> updatePerformance(int id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deletePerformance(int id);
}
