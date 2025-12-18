import '../../../../core/config/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/dashboard_stats_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardResponse> getDashboard();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final DioClient _client;

  DashboardRemoteDataSourceImpl({required DioClient client}) : _client = client;

  @override
  Future<DashboardResponse> getDashboard() async {
    final response = await _client.get(ApiEndpoints.dashboard);
    final data = response.data as Map<String, dynamic>;
    return DashboardResponse.fromJson(data);
  }
}
