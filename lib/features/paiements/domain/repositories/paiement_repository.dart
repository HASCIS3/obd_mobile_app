import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/models/paiement_model.dart';

abstract class PaiementRepository {
  Future<Either<Failure, List<PaiementModel>>> getPaiements({
    int? athleteId,
    String? mois,
  });
  Future<Either<Failure, PaiementModel>> getPaiement(int id);
  Future<Either<Failure, PaiementModel>> createPaiement(Map<String, dynamic> data);
  Future<Either<Failure, PaiementModel>> updatePaiement(int id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deletePaiement(int id);
  Future<Either<Failure, List<PaiementModel>>> getArrieres();
}
