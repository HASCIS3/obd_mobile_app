import '../../../../core/config/api_endpoints.dart';
import '../../../../core/models/athlete_model.dart';
import '../../../../core/network/dio_client.dart';

abstract class AthleteRemoteDataSource {
  Future<List<AthleteModel>> getAthletes({String? search, bool? actif});
  Future<AthleteModel> getAthlete(int id);
  Future<AthleteModel> createAthlete(Map<String, dynamic> data);
  Future<AthleteModel> updateAthlete(int id, Map<String, dynamic> data);
  Future<void> deleteAthlete(int id);
}

class AthleteRemoteDataSourceImpl implements AthleteRemoteDataSource {
  final DioClient _client;

  AthleteRemoteDataSourceImpl({required DioClient client}) : _client = client;

  @override
  Future<List<AthleteModel>> getAthletes({String? search, bool? actif}) async {
    final queryParams = <String, dynamic>{};
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (actif != null) queryParams['actif'] = actif ? '1' : '0';

    final response = await _client.get(
      ApiEndpoints.athletes,
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
        .map((json) => AthleteModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<AthleteModel> getAthlete(int id) async {
    final response = await _client.get(ApiEndpoints.athlete(id));
    final data = response.data as Map<String, dynamic>;
    
    if (data.containsKey('data')) {
      return AthleteModel.fromJson(data['data'] as Map<String, dynamic>);
    }
    return AthleteModel.fromJson(data);
  }

  @override
  Future<AthleteModel> createAthlete(Map<String, dynamic> data) async {
    final response = await _client.post(ApiEndpoints.athletes, data: data);
    final responseData = response.data as Map<String, dynamic>;
    
    if (responseData.containsKey('data')) {
      return AthleteModel.fromJson(responseData['data'] as Map<String, dynamic>);
    }
    return AthleteModel.fromJson(responseData);
  }

  @override
  Future<AthleteModel> updateAthlete(int id, Map<String, dynamic> data) async {
    final response = await _client.put(ApiEndpoints.athlete(id), data: data);
    final responseData = response.data as Map<String, dynamic>;
    
    if (responseData.containsKey('data')) {
      return AthleteModel.fromJson(responseData['data'] as Map<String, dynamic>);
    }
    return AthleteModel.fromJson(responseData);
  }

  @override
  Future<void> deleteAthlete(int id) async {
    await _client.delete(ApiEndpoints.athlete(id));
  }
}
