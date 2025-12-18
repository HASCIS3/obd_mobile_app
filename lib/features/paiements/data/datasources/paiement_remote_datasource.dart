import '../../../../core/config/api_endpoints.dart';
import '../../../../core/models/paiement_model.dart';
import '../../../../core/network/dio_client.dart';

abstract class PaiementRemoteDataSource {
  Future<List<PaiementModel>> getPaiements({int? athleteId, String? mois});
  Future<PaiementModel> getPaiement(int id);
  Future<PaiementModel> createPaiement(Map<String, dynamic> data);
  Future<PaiementModel> updatePaiement(int id, Map<String, dynamic> data);
  Future<void> deletePaiement(int id);
  Future<List<PaiementModel>> getArrieres();
}

class PaiementRemoteDataSourceImpl implements PaiementRemoteDataSource {
  final DioClient _client;

  PaiementRemoteDataSourceImpl({required DioClient client}) : _client = client;

  @override
  Future<List<PaiementModel>> getPaiements({int? athleteId, String? mois}) async {
    final queryParams = <String, dynamic>{};
    if (athleteId != null) queryParams['athlete_id'] = athleteId;
    if (mois != null) queryParams['mois'] = mois;

    final response = await _client.get(
      ApiEndpoints.paiements,
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
        .map((json) => PaiementModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PaiementModel> getPaiement(int id) async {
    final response = await _client.get(ApiEndpoints.paiement(id));
    final data = response.data as Map<String, dynamic>;
    
    if (data.containsKey('data')) {
      return PaiementModel.fromJson(data['data'] as Map<String, dynamic>);
    }
    return PaiementModel.fromJson(data);
  }

  @override
  Future<PaiementModel> createPaiement(Map<String, dynamic> data) async {
    final response = await _client.post(ApiEndpoints.paiements, data: data);
    final responseData = response.data as Map<String, dynamic>;
    
    if (responseData.containsKey('data')) {
      return PaiementModel.fromJson(responseData['data'] as Map<String, dynamic>);
    }
    return PaiementModel.fromJson(responseData);
  }

  @override
  Future<PaiementModel> updatePaiement(int id, Map<String, dynamic> data) async {
    final response = await _client.put(ApiEndpoints.paiement(id), data: data);
    final responseData = response.data as Map<String, dynamic>;
    
    if (responseData.containsKey('data')) {
      return PaiementModel.fromJson(responseData['data'] as Map<String, dynamic>);
    }
    return PaiementModel.fromJson(responseData);
  }

  @override
  Future<void> deletePaiement(int id) async {
    await _client.delete(ApiEndpoints.paiement(id));
  }

  @override
  Future<List<PaiementModel>> getArrieres() async {
    final response = await _client.get(ApiEndpoints.paiementsArrieres);
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
        .map((json) => PaiementModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
