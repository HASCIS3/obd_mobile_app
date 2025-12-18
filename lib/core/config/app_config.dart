/// Configuration de l'application OBD Mobile
class AppConfig {
  AppConfig._();

  // API Configuration
  // Pour téléphone physique: utilisez l'IP de votre PC sur le réseau local
  // Exemple: 'http://192.168.1.100:8000/api'
  // Pour émulateur Android: 'http://10.0.2.2:8000/api'
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.0.116:8000/api', // IP Wi-Fi de votre PC
  );

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Cache
  static const Duration cacheMaxAge = Duration(hours: 1);

  // Pagination
  static const int defaultPageSize = 20;

  // Session
  static const Duration sessionTimeout = Duration(days: 7);

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String localeKey = 'locale';

  // App Info
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
}
