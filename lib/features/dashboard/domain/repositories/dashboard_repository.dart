import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/dashboard_stats_model.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardResponse>> getDashboard();
}
