import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/models/athlete_model.dart';

abstract class AthleteRepository {
  Future<Either<Failure, List<AthleteModel>>> getAthletes({
    String? search,
    bool? actif,
  });
  Future<Either<Failure, AthleteModel>> getAthlete(int id);
  Future<Either<Failure, AthleteModel>> createAthlete(Map<String, dynamic> data);
  Future<Either<Failure, AthleteModel>> updateAthlete(int id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteAthlete(int id);
}
