/// Configurações globais da aplicação
class AppConfig {
  // Configuração de ambiente
  static const String _environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  static bool get isDevelopment => _environment == 'development';
  static bool get isProduction => _environment == 'production';
  static bool get isStaging => _environment == 'staging';

  // Configuração de API
  static String get baseUrl {
    switch (_environment) {
      case 'production':
        return 'https://api.finance-app.com/v1';
      case 'staging':
        return 'https://staging-api.finance-app.com/v1';
      default:
        return 'https://dev-api.finance-app.com/v1';
    }
  }

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Configurações de cache
  static const Duration cacheExpiry = Duration(hours: 24);
  static const int maxCacheSize = 100; // MB

  // Configurações de paginação
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Configurações de autenticação
  static const Duration tokenRefreshThreshold = Duration(minutes: 5);
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';

  // Configurações de desenvolvimento
  static bool get enableDevMode => isDevelopment;
  static bool get enableLogging => !isProduction;
  static bool get enableMockData => isDevelopment;

  // Versão do app
  static const String appVersion = '1.0.0';
  static const int appBuildNumber = 1;
}
