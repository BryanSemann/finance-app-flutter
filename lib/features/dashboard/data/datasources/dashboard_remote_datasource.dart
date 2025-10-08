import '../models/financial_summary_model.dart';
import '../models/dashboard_chart_model.dart';
import '../models/recent_transaction_model.dart';

/// Interface para data source remoto do dashboard
abstract class DashboardRemoteDataSource {
  /// Busca resumo financeiro do mês
  Future<FinancialSummaryModel> getFinancialSummary({required DateTime month});

  /// Busca resumo financeiro de um período
  Future<FinancialSummaryModel> getFinancialSummaryByPeriod({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Busca dados para gráficos
  Future<List<DashboardChartModel>> getDashboardCharts({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Busca gráfico de despesas por categoria
  Future<DashboardChartModel> getExpensesByCategory({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Busca gráfico de receitas vs despesas
  Future<DashboardChartModel> getIncomeVsExpenses({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Busca evolução do saldo
  Future<DashboardChartModel> getBalanceEvolution({required int monthsBack});

  /// Busca transações recentes
  Future<List<RecentTransactionModel>> getRecentTransactions({
    required int limit,
  });

  /// Busca transações do dia
  Future<List<RecentTransactionModel>> getTodayTransactions();

  /// Busca meta vs realizado do mês
  Future<Map<String, double>> getMonthlyBudget({required DateTime month});
}
