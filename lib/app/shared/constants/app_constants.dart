// Constantes de tempo e delays
class AppConstants {
  // Delays de API
  static const Duration defaultApiDelay = Duration(milliseconds: 300);
  static const Duration mockApiDelay = Duration(milliseconds: 500);

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 10);

  // Paginação
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Limites de transações
  static const int minInstallments = 2;
  static const int maxInstallments = 24;
  static const double maxTransactionAmount = 1000000.00;

  // Cache
  static const Duration tokenCacheTime = Duration(hours: 24);
  static const Duration dataCacheTime = Duration(minutes: 30);

  // Validações
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int maxDescriptionLength = 255;

  // Formato de dados
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String currencySymbol = 'R\$';
}

// Constantes de strings para internacionalização
class AppStrings {
  // Erros comuns
  static const String errorLoadingTransactions = 'Erro ao carregar transações';
  static const String errorInvalidCredentials = 'Email ou senha inválidos';
  static const String errorNetworkConnection = 'Erro de conexão de rede';
  static const String errorUnknown = 'Erro desconhecido';

  // Mensagens de sucesso
  static const String successLogin = 'Login realizado com sucesso';
  static const String successLogout = 'Logout realizado com sucesso';
  static const String successTransactionCreated =
      'Transação criada com sucesso';
  static const String successTransactionUpdated =
      'Transação atualizada com sucesso';
  static const String successTransactionDeleted =
      'Transação excluída com sucesso';

  // Labels gerais
  static const String email = 'Email';
  static const String password = 'Senha';
  static const String name = 'Nome';
  static const String description = 'Descrição';
  static const String amount = 'Valor';
  static const String category = 'Categoria';
  static const String date = 'Data';

  // Botões
  static const String save = 'Salvar';
  static const String cancel = 'Cancelar';
  static const String delete = 'Excluir';
  static const String edit = 'Editar';
  static const String duplicate = 'Duplicar';
  static const String login = 'Entrar';
  static const String logout = 'Sair';
  static const String register = 'Registrar';
}
