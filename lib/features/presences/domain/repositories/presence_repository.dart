import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/models/presence_model.dart';

abstract class PresenceRepository {
  Future<Either<Failure, List<PresenceModel>>> getPresences({
    int? athleteId,
    String? date,
  });
  Future<Either<Failure, PresenceModel>> createPresence(Map<String, dynamic> data);
  Future<Either<Failure, PresenceModel>> updatePresence(int id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deletePresence(int id);
  Future<Either<Failure, void>> pointageMasse(List<Map<String, dynamic>> presences);
}
