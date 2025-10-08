/// Endpoints da API organizados por feature
class ApiEndpoints {
  // Base
  static const String auth = '/auth';
  static const String users = '/users';
  static const String transactions = '/transactions';
  static const String categories = '/categories';
  static const String reports = '/reports';
  static const String dashboard = '/dashboard';

  // Authentication
  static const String login = '$auth/login';
  static const String register = '$auth/register';
  static const String refreshToken = '$auth/refresh';
  static const String logout = '$auth/logout';
  static const String forgotPassword = '$auth/forgot-password';
  static const String resetPassword = '$auth/reset-password';
  static const String changePassword = '$auth/change-password';

  // User Profile
  static const String profile = '$users/profile';
  static const String updateProfile = '$users/profile';
  static const String deleteAccount = '$users/delete-account';

  // Transactions
  static const String getTransactions = transactions;
  static const String createTransaction = transactions;
  static const String updateTransaction = '$transactions/{id}';
  static const String deleteTransaction = '$transactions/{id}';
  static const String getTransaction = '$transactions/{id}';
  static const String bulkTransactions = '$transactions/bulk';

  // Categories
  static const String getCategories = categories;
  static const String createCategory = categories;
  static const String updateCategory = '$categories/{id}';
  static const String deleteCategory = '$categories/{id}';

  // Reports
  static const String financialSummary = '$reports/summary';
  static const String monthlyReport = '$reports/monthly';
  static const String categoryReport = '$reports/categories';
  static const String trendsReport = '$reports/trends';
  static const String exportReport = '$reports/export';

  // Utility method to replace path parameters
  static String replacePathParams(String endpoint, Map<String, String> params) {
    String result = endpoint;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }
}
