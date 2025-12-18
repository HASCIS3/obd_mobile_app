import '../../../../core/config/api_endpoints.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/network/dio_client.dart';

/// Interface pour les opérations d'authentification distantes
abstract class AuthRemoteDataSource {
  Future<AuthResponse> login(String email, String password);
  Future<void> logout();
  Future<UserModel> getCurrentUser();
  Future<void> forgotPassword(String email);
}

/// Réponse d'authentification
class AuthResponse {
  final String token;
  final UserModel user;

  const AuthResponse({
    required this.token,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

/// Implémentation du datasource d'authentification
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _client;

  AuthRemoteDataSourceImpl({required DioClient client}) : _client = client;

  @override
  Future<AuthResponse> login(String email, String password) async {
    final response = await _client.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    final data = response.data as Map<String, dynamic>;
    final authResponse = AuthResponse.fromJson(data);
    
    // Stocker le token dans le client
    _client.setAuthToken(authResponse.token);
    
    return authResponse;
  }

  @override
  Future<void> logout() async {
    try {
      await _client.post(ApiEndpoints.logout);
    } finally {
      _client.setAuthToken(null);
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await _client.get(ApiEndpoints.user);
    final data = response.data as Map<String, dynamic>;
    return UserModel.fromJson(data);
  }

  @override
  Future<void> forgotPassword(String email) async {
    await _client.post(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
    );
  }
}
