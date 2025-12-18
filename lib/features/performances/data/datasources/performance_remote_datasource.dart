import '../../../../core/config/api_endpoints.dart';
import '../../../../core/models/performance_model.dart';
import '../../../../core/network/dio_client.dart';

abstract class PerformanceRemoteDataSource {
  Future<List<PerformanceModel>> getPerformances({int? athleteId});
  Future<PerformanceModel> getPerformance(int id);
  Future<PerformanceModel> createPerformance(Map<String, dynamic> data);
  Future<PerformanceModel> updatePerformance(int id, Map<String, dynamic> data);
  Future<void> deletePerformance(int id);
}

class PerformanceRemoteDataSourceImpl implements PerformanceRemoteDataSource {
  final DioClient _client;

  PerformanceRemoteDataSourceImpl({required DioClient client}) : _client = client;

  @override
  Future<List<PerformanceModel>> getPerformances({int? athleteId}) async {
    final queryParams = <String, dynamic>{};
    if (athleteId != null) queryParams['athlete_id'] = athleteId;

    final response = await _client.get(
      ApiEndpoints.performances,
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
        .map((json) => PerformanceModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PerformanceModel> getPerformance(int id) async {
    final response = await _client.get(ApiEndpoints.performance(id));
    final data = response.data as Map<String, dynamic>;
    
    if (data.containsKey('data')) {
      return PerformanceModel.fromJson(data['data'] as Map<String, dynamic>);
    }
    return PerformanceModel.fromJson(data);
  }

  @override
  Future<PerformanceModel> createPerformance(Map<String, dynamic> data) async {
    final response = await _client.post(ApiEndpoints.performances, data: data);
    final responseData = response.data as Map<String, dynamic>;
    
    if (responseData.containsKey('data')) {
      return PerformanceModel.fromJson(responseData['data'] as Map<String, dynamic>);
    }
    return PerformanceModel.fromJson(responseData);
  }

  @override
  Future<PerformanceModel> updatePerformance(int id, Map<String, dynamic> data) async {
    final response = await _client.put(ApiEndpoints.performance(id), data: data);
    final responseData = response.data as Map<String, dynamic>;
    
    if (responseData.containsKey('data')) {
      return PerformanceModel.fromJson(responseData['data'] as Map<String, dynamic>);
    }
    return PerformanceModel.fromJson(responseData);
  }

  @override
  Future<void> deletePerformance(int id) async {
    await _client.delete(ApiEndpoints.performance(id));
  }
}
