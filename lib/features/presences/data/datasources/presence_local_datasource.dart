import '../../../../core/models/presence_model.dart';
import '../../../../core/services/local_storage_service.dart';

abstract class PresenceLocalDataSource {
  List<PresenceModel> getPresences();
  Future<void> savePresences(List<PresenceModel> presences);
  Future<void> addPresence(PresenceModel presence);
}

class PresenceLocalDataSourceImpl implements PresenceLocalDataSource {
  @override
  List<PresenceModel> getPresences() {
    final data = LocalStorageService.getPresences();
    return data.map((json) => PresenceModel.fromJson(json)).toList();
  }

  @override
  Future<void> savePresences(List<PresenceModel> presences) async {
    final data = presences.map((p) => p.toJson()).toList();
    await LocalStorageService.savePresences(data);
  }

  @override
  Future<void> addPresence(PresenceModel presence) async {
    final presences = getPresences();
    presences.add(presence);
    await savePresences(presences);
  }
}
