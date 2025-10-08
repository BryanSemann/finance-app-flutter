/// Strings da aplicação para facilitar internacionalização futura
class AppStrings {
  // Geral
  static const String appName = 'Finance App';
  static const String ok = 'OK';
  static const String cancel = 'Cancelar';
  static const String save = 'Salvar';
  static const String delete = 'Excluir';
  static const String edit = 'Editar';
  static const String loading = 'Carregando...';
  static const String error = 'Erro';
  static const String success = 'Sucesso';
  static const String warning = 'Atenção';
  static const String retry = 'Tentar novamente';
  static const String noData = 'Nenhum dado encontrado';

  // Autenticação
  static const String login = 'Entrar';
  static const String register = 'Cadastrar';
  static const String logout = 'Sair';
  static const String email = 'E-mail';
  static const String password = 'Senha';
  static const String confirmPassword = 'Confirmar Senha';
  static const String name = 'Nome';
  static const String forgotPassword = 'Esqueci minha senha';
  static const String dontHaveAccount = 'Não tem conta?';
  static const String alreadyHaveAccount = 'Já tem conta?';
  static const String createAccount = 'Criar conta';

  // Validações
  static const String fieldRequired = 'Este campo é obrigatório';
  static const String invalidEmail = 'E-mail inválido';
  static const String passwordTooShort =
      'Senha deve ter pelo menos 6 caracteres';
  static const String passwordsDontMatch = 'Senhas não coincidem';
  static const String invalidCredentials = 'Credenciais inválidas';

  // Dashboard
  static const String dashboard = 'Dashboard';
  static const String totalBalance = 'Saldo Total';
  static const String monthlyIncome = 'Receita Mensal';
  static const String monthlyExpenses = 'Despesas Mensais';
  static const String recentTransactions = 'Transações Recentes';
  static const String viewAll = 'Ver todas';

  // Transações
  static const String transactions = 'Transações';
  static const String newTransaction = 'Nova Transação';
  static const String income = 'Receita';
  static const String expense = 'Despesa';
  static const String description = 'Descrição';
  static const String amount = 'Valor';
  static const String category = 'Categoria';
  static const String date = 'Data';
  static const String notes = 'Observações';

  // Categorias
  static const String categories = 'Categorias';
  static const String newCategory = 'Nova Categoria';
  static const String categoryName = 'Nome da Categoria';
  static const String categoryIcon = 'Ícone';
  static const String categoryColor = 'Cor';

  // Relatórios
  static const String reports = 'Relatórios';
  static const String monthlyReport = 'Relatório Mensal';
  static const String categoryReport = 'Por Categoria';
  static const String trends = 'Tendências';
  static const String export = 'Exportar';

  // Erros
  static const String networkError = 'Erro de conexão com a internet';
  static const String serverError = 'Erro interno do servidor';
  static const String authError = 'Erro de autenticação';
  static const String validationError = 'Erro de validação';
  static const String cacheError = 'Erro no cache local';
  static const String unexpectedError = 'Erro inesperado';
  static const String notFoundError = 'Recurso não encontrado';

  // Sucesso
  static const String loginSuccess = 'Login realizado com sucesso';
  static const String registerSuccess = 'Cadastro realizado com sucesso';
  static const String transactionSaved = 'Transação salva com sucesso';
  static const String transactionDeleted = 'Transação excluída com sucesso';
  static const String categorySaved = 'Categoria salva com sucesso';
  static const String categoryDeleted = 'Categoria excluída com sucesso';
}
