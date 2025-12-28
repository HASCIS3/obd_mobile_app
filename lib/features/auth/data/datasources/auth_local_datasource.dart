import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/models/user_model.dart';

/// Interface pour le stockage local d'authentification
abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> deleteUser();
  Future<void> saveCredentials(String email, String password);
  Future<Map<String, String>?> getCredentials();
  Future<void> clearAll();
}

/// Implémentation du stockage local sécurisé
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _storage;

  AuthLocalDataSourceImpl({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: AppConfig.tokenKey, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await _storage.read(key: AppConfig.tokenKey);
  }

  @override
  Future<void> deleteToken() async {
    await _storage.delete(key: AppConfig.tokenKey);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _storage.write(key: AppConfig.userKey, value: userJson);
  }

  @override
  Future<UserModel?> getUser() async {
    final userJson = await _storage.read(key: AppConfig.userKey);
    if (userJson == null) return null;
    
    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> deleteUser() async {
    await _storage.delete(key: AppConfig.userKey);
  }

  static const String _credentialsKey = 'offline_credentials';

  @override
  Future<void> saveCredentials(String email, String password) async {
    final credentials = jsonEncode({'email': email, 'password': password});
    await _storage.write(key: _credentialsKey, value: credentials);
  }

  @override
  Future<Map<String, String>?> getCredentials() async {
    final credentialsJson = await _storage.read(key: _credentialsKey);
    if (credentialsJson == null) return null;
    
    try {
      final map = jsonDecode(credentialsJson) as Map<String, dynamic>;
      return {'email': map['email'] as String, 'password': map['password'] as String};
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearAll() async {
    await deleteToken();
    await deleteUser();
    await _storage.delete(key: _credentialsKey);
  }
}
