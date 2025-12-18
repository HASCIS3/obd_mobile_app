import '../../../../core/config/api_endpoints.dart';
import '../../../../core/models/discipline_model.dart';
import '../../../../core/network/dio_client.dart';

abstract class DisciplineRemoteDataSource {
  Future<List<DisciplineModel>> getDisciplines();
  Future<DisciplineModel> getDiscipline(int id);
}

class DisciplineRemoteDataSourceImpl implements DisciplineRemoteDataSource {
  final DioClient _client;

  DisciplineRemoteDataSourceImpl({required DioClient client}) : _client = client;

  @override
  Future<List<DisciplineModel>> getDisciplines() async {
    final response = await _client.get(ApiEndpoints.disciplines);
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
        .map((json) => DisciplineModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<DisciplineModel> getDiscipline(int id) async {
    final response = await _client.get(ApiEndpoints.discipline(id));
    final data = response.data as Map<String, dynamic>;
    
    if (data.containsKey('data')) {
      return DisciplineModel.fromJson(data['data'] as Map<String, dynamic>);
    }
    return DisciplineModel.fromJson(data);
  }
}
