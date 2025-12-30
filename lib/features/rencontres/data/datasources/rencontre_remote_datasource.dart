import '../../../../core/config/api_endpoints.dart';
import '../../../../core/models/rencontre_model.dart';
import '../../../../core/network/dio_client.dart';

/// Interface pour les opérations de rencontres distantes
abstract class RencontreRemoteDataSource {
  Future<List<RencontreModel>> getRencontres({
    int? disciplineId,
    String? resultat,
    DateTime? dateDebut,
    DateTime? dateFin,
  });
  Future<RencontreModel> getRencontre(int id);
  Future<List<RencontreModel>> getRencontresAVenir();
  Future<List<RencontreModel>> getDerniersResultats();
  Future<RencontreModel> createRencontre(Map<String, dynamic> data);
  Future<RencontreModel> updateRencontre(int id, Map<String, dynamic> data);
  Future<void> deleteRencontre(int id);
}

/// Implémentation du datasource de rencontres
class RencontreRemoteDataSourceImpl implements RencontreRemoteDataSource {
  final DioClient _client;

  RencontreRemoteDataSourceImpl({required DioClient client}) : _client = client;

  @override
  Future<List<RencontreModel>> getRencontres({
    int? disciplineId,
    String? resultat,
    DateTime? dateDebut,
    DateTime? dateFin,
  }) async {
    final queryParams = <String, dynamic>{};
    if (disciplineId != null) queryParams['discipline_id'] = disciplineId;
    if (resultat != null) queryParams['resultat'] = resultat;
    if (dateDebut != null) queryParams['date_debut'] = dateDebut.toIso8601String().split('T')[0];
    if (dateFin != null) queryParams['date_fin'] = dateFin.toIso8601String().split('T')[0];

    final response = await _client.get(
      ApiEndpoints.rencontres,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final data = response.data;
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      final list = data['data'] as List;
      return list.map((e) => RencontreModel.fromJson(e)).toList();
    } else if (data is List) {
      return data.map((e) => RencontreModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<RencontreModel> getRencontre(int id) async {
    final response = await _client.get(ApiEndpoints.rencontre(id));
    final data = response.data;
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      return RencontreModel.fromJson(data['data']);
    }
    return RencontreModel.fromJson(data);
  }

  @override
  Future<List<RencontreModel>> getRencontresAVenir() async {
    final response = await _client.get(ApiEndpoints.rencontresAVenir);
    final data = response.data;
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      final list = data['data'] as List;
      return list.map((e) => RencontreModel.fromJson(e)).toList();
    } else if (data is List) {
      return data.map((e) => RencontreModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<List<RencontreModel>> getDerniersResultats() async {
    final response = await _client.get(ApiEndpoints.rencontresResultats);
    final data = response.data;
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      final list = data['data'] as List;
      return list.map((e) => RencontreModel.fromJson(e)).toList();
    } else if (data is List) {
      return data.map((e) => RencontreModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<RencontreModel> createRencontre(Map<String, dynamic> data) async {
    final response = await _client.post(ApiEndpoints.rencontres, data: data);
    final responseData = response.data;
    if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
      return RencontreModel.fromJson(responseData['data']);
    }
    return RencontreModel.fromJson(responseData);
  }

  @override
  Future<RencontreModel> updateRencontre(int id, Map<String, dynamic> data) async {
    final response = await _client.put(ApiEndpoints.rencontre(id), data: data);
    final responseData = response.data;
    if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
      return RencontreModel.fromJson(responseData['data']);
    }
    return RencontreModel.fromJson(responseData);
  }

  @override
  Future<void> deleteRencontre(int id) async {
    await _client.delete(ApiEndpoints.rencontre(id));
  }
}
