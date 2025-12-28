import '../../../../core/models/paiement_model.dart';
import '../../../../core/services/local_storage_service.dart';

abstract class PaiementLocalDataSource {
  List<PaiementModel> getPaiements();
  Future<void> savePaiements(List<PaiementModel> paiements);
  Future<void> addPaiement(PaiementModel paiement);
}

class PaiementLocalDataSourceImpl implements PaiementLocalDataSource {
  @override
  List<PaiementModel> getPaiements() {
    final data = LocalStorageService.getPaiements();
    return data.map((json) => PaiementModel.fromJson(json)).toList();
  }

  @override
  Future<void> savePaiements(List<PaiementModel> paiements) async {
    final data = paiements.map((p) => p.toJson()).toList();
    await LocalStorageService.savePaiements(data);
  }

  @override
  Future<void> addPaiement(PaiementModel paiement) async {
    final paiements = getPaiements();
    paiements.add(paiement);
    await savePaiements(paiements);
  }
}
