import '../../../../core/config/api_endpoints.dart';
import '../../../../core/models/presence_model.dart';
import '../../../../core/network/dio_client.dart';

abstract class PresenceRemoteDataSource {
  Future<List<PresenceModel>> getPresences({int? athleteId, String? date});
  Future<PresenceModel> getPresence(int id);
  Future<PresenceModel> createPresence(Map<String, dynamic> data);
  Future<PresenceModel> updatePresence(int id, Map<String, dynamic> data);
  Future<void> deletePresence(int id);
  Future<void> pointageMasse(List<Map<String, dynamic>> presences);
}

class PresenceRemoteDataSourceImpl implements PresenceRemoteDataSource {
  final DioClient _client;

  PresenceRemoteDataSourceImpl({required DioClient client}) : _client = client;

  @override
  Future<List<PresenceModel>> getPresences({int? athleteId, String? date}) async {
    final queryParams = <String, dynamic>{};
    if (athleteId != null) queryParams['athlete_id'] = athleteId;
    if (date != null) queryParams['date'] = date;

    final response = await _client.get(
      ApiEndpoints.presences,
      queryParameters: queryParams,
    );

    final data = response.data;
    List<dynamic> list;
    
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      list = data['data'] as List<dynamic>;
    } else if (data is List) {
      list = data;
    } else {
      list = [];
    }

    return list
        .map((json) => PresenceModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PresenceModel> getPresence(int id) async {
    final response = await _client.get(ApiEndpoints.presence(id));
    final data = response.data as Map<String, dynamic>;
    
    if (data.containsKey('data')) {
      return PresenceModel.fromJson(data['data'] as Map<String, dynamic>);
    }
    return PresenceModel.fromJson(data);
  }

  @override
  Future<PresenceModel> createPresence(Map<String, dynamic> data) async {
    final response = await _client.post(ApiEndpoints.presences, data: data);
    final responseData = response.data as Map<String, dynamic>;
    
    if (responseData.containsKey('data')) {
      return PresenceModel.fromJson(responseData['data'] as Map<String, dynamic>);
    }
    return PresenceModel.fromJson(responseData);
  }

  @override
  Future<PresenceModel> updatePresence(int id, Map<String, dynamic> data) async {
    final response = await _client.put(ApiEndpoints.presence(id), data: data);
    final responseData = response.data as Map<String, dynamic>;
    
    if (responseData.containsKey('data')) {
      return PresenceModel.fromJson(responseData['data'] as Map<String, dynamic>);
    }
    return PresenceModel.fromJson(responseData);
  }

  @override
  Future<void> deletePresence(int id) async {
    await _client.delete(ApiEndpoints.presence(id));
  }

  @override
  Future<void> pointageMasse(List<Map<String, dynamic>> presences) async {
    // Créer chaque présence individuellement
    for (var presence in presences) {
      try {
        await _client.post(ApiEndpoints.presences, data: presence);
      } catch (e) {
        // Continuer même si une présence échoue (peut-être déjà existante)
        continue;
      }
    }
  }
}
