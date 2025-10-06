class ApiConstants {
  // Base URL do seu backend
  static const String baseUrl = 'https://your-backend-api.com/api';

  // Versão da API
  static const String apiVersion = 'v1';

  // Endpoints
  static const String transactions = '/transactions';
  static const String categories = '/categories';
  static const String reports = '/reports';
  static const String auth = '/auth';

  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Configurações de desenvolvimento
  static const bool isDevelopmentMode = true; // Altere para false em produção

  // Credenciais de desenvolvimento (globais)
  static const Map<String, String> devCredentials = {
    'dev@finance.com': 'dev123',
    'admin@finance.com': 'admin123',
    'test@finance.com': 'test123',
  };

  // Token fixo para desenvolvimento
  static const String devToken = 'dev_token_12345';
}
