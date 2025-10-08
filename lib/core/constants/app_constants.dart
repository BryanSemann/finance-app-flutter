/// Constantes gerais da aplicação
class AppConstants {
  AppConstants._();

  // API
  static const String apiBaseUrl = 'https://api.financeapp.com';
  static const int apiTimeout = 30000; // 30 segundos

  // Chaves de storage
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';

  // Validação
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int maxNameLength = 100;

  // Formatação
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String currencySymbol = 'R\$';

  // Paginação
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}
