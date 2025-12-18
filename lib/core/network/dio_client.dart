import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config/app_config.dart';
import '../errors/exceptions.dart';
import 'network_info.dart';

/// Client HTTP Dio configuré pour l'application
class DioClient {
  final Dio _dio;
  final NetworkInfo _networkInfo;
  String? _authToken;

  DioClient({
    required NetworkInfo networkInfo,
    Dio? dio,
  })  : _networkInfo = networkInfo,
        _dio = dio ?? Dio() {
    _dio.options = BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      sendTimeout: AppConfig.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio.interceptors.addAll([
      _AuthInterceptor(this),
      _ErrorInterceptor(_networkInfo),
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
    ]);
  }

  /// Définir le token d'authentification
  void setAuthToken(String? token) {
    _authToken = token;
  }

  /// Récupérer le token d'authentification
  String? get authToken => _authToken;

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Upload file
  Future<Response<T>> uploadFile<T>(
    String path, {
    required FormData formData,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    return _dio.post<T>(
      path,
      data: formData,
      options: options ?? Options(contentType: 'multipart/form-data'),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
  }
}

/// Interceptor pour ajouter le token d'authentification
class _AuthInterceptor extends Interceptor {
  final DioClient _client;

  _AuthInterceptor(this._client);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _client.authToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

/// Interceptor pour gérer les erreurs
class _ErrorInterceptor extends Interceptor {
  final NetworkInfo _networkInfo;

  _ErrorInterceptor(this._networkInfo);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Vérifier la connexion réseau
    if (!await _networkInfo.isConnected) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: const NetworkException(),
          type: DioExceptionType.connectionError,
        ),
      );
      return;
    }

    // Gérer les erreurs HTTP
    final statusCode = err.response?.statusCode;
    final data = err.response?.data;

    AppException exception;

    switch (statusCode) {
      case 401:
        exception = AuthenticationException(
          message: _extractMessage(data) ?? 'Session expirée',
          statusCode: statusCode,
          data: data,
        );
        break;
      case 403:
        exception = AuthorizationException(
          message: _extractMessage(data) ?? 'Accès refusé',
          statusCode: statusCode,
          data: data,
        );
        break;
      case 404:
        exception = NotFoundException(
          message: _extractMessage(data) ?? 'Ressource non trouvée',
          statusCode: statusCode,
          data: data,
        );
        break;
      case 422:
        exception = ValidationException(
          message: _extractMessage(data) ?? 'Données invalides',
          statusCode: statusCode,
          data: data,
          errors: _extractValidationErrors(data),
        );
        break;
      case 500:
      case 502:
      case 503:
        exception = ServerException(
          message: _extractMessage(data) ?? 'Erreur serveur',
          statusCode: statusCode,
          data: data,
        );
        break;
      default:
        if (err.type == DioExceptionType.connectionTimeout ||
            err.type == DioExceptionType.receiveTimeout ||
            err.type == DioExceptionType.sendTimeout) {
          exception = const TimeoutException();
        } else {
          exception = ServerException(
            message: _extractMessage(data) ?? err.message ?? 'Erreur inconnue',
            statusCode: statusCode,
            data: data,
          );
        }
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: exception,
        response: err.response,
        type: err.type,
      ),
    );
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String?;
    }
    return null;
  }

  Map<String, List<String>>? _extractValidationErrors(dynamic data) {
    if (data is Map<String, dynamic> && data['errors'] is Map) {
      final errors = data['errors'] as Map<String, dynamic>;
      return errors.map((key, value) {
        if (value is List) {
          return MapEntry(key, value.cast<String>());
        }
        return MapEntry(key, [value.toString()]);
      });
    }
    return null;
  }
}
