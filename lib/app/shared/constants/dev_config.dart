class DevConfig {
  // Controle global do modo de desenvolvimento
  static const bool enableDevMode = true;

  // Configurações específicas do desenvolvimento
  static const bool autoLogin =
      false; // Login automático no modo dev (DESABILITADO)
  static const String defaultDevUser = 'dev@finance.com';

  // Configurações de debug
  static const bool showDevInfo = true;
  static const bool logApiCalls = true;

  // Bypass de validações em desenvolvimento
  static const bool skipEmailValidation = true;
  static const bool skipPasswordStrength = true;

  // Dados de teste para desenvolvimento
  static const Map<String, Map<String, dynamic>> testUsers = {
    'dev@finance.com': {
      'name': 'Desenvolvedor',
      'role': 'admin',
      'permissions': ['read', 'write', 'delete'],
    },
    'admin@finance.com': {
      'name': 'Administrador',
      'role': 'admin',
      'permissions': ['read', 'write', 'delete', 'manage_users'],
    },
    'test@finance.com': {
      'name': 'Usuário de Teste',
      'role': 'user',
      'permissions': ['read', 'write'],
    },
  };

  // Método para verificar se estamos em modo de desenvolvimento
  static bool get isDevMode => enableDevMode;

  // Método para obter informações do usuário de teste
  static Map<String, dynamic>? getTestUserInfo(String email) {
    return testUsers[email];
  }
}
