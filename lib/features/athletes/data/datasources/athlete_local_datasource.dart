import '../../../../core/models/athlete_model.dart';
import '../../../../core/services/local_storage_service.dart';

abstract class AthleteLocalDataSource {
  List<AthleteModel> getAthletes();
  AthleteModel? getAthlete(int id);
  Future<void> saveAthletes(List<AthleteModel> athletes);
  Future<void> saveAthlete(AthleteModel athlete);
  Future<void> deleteAthlete(int id);
}

class AthleteLocalDataSourceImpl implements AthleteLocalDataSource {
  @override
  List<AthleteModel> getAthletes() {
    final data = LocalStorageService.getAthletes();
    return data.map((json) => AthleteModel.fromJson(json)).toList();
  }

  @override
  AthleteModel? getAthlete(int id) {
    final athletes = getAthletes();
    try {
      return athletes.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveAthletes(List<AthleteModel> athletes) async {
    final data = athletes.map((a) => a.toJson()).toList();
    await LocalStorageService.saveAthletes(data);
  }

  @override
  Future<void> saveAthlete(AthleteModel athlete) async {
    await LocalStorageService.saveAthlete(athlete.toJson());
  }

  @override
  Future<void> deleteAthlete(int id) async {
    final athletes = getAthletes();
    final filtered = athletes.where((a) => a.id != id).toList();
    await saveAthletes(filtered);
  }
}
