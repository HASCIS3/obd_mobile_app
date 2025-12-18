import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/models/discipline_model.dart';

abstract class DisciplineRepository {
  Future<Either<Failure, List<DisciplineModel>>> getDisciplines();
  Future<Either<Failure, DisciplineModel>> getDiscipline(int id);
}
