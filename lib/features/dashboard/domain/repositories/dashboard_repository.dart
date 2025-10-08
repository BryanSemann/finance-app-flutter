import '../../../../core/errors/failures.dart';
import '../entities/financial_summary.dart';
import '../entities/dashboard_chart.dart';
import '../entities/recent_transaction.dart';

/// Repositório para dados do dashboard
abstract class DashboardRepository {
  /// Busca resumo financeiro do mês
  Future<({Failure? failure, FinancialSummary? summary})> getFinancialSummary({
    required DateTime month,
  });

  /// Busca resumo financeiro de um período
  Future<({Failure? failure, FinancialSummary? summary})>
  getFinancialSummaryByPeriod({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Busca dados para gráficos
  Future<({Failure? failure, List<DashboardChart> charts})> getDashboardCharts({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Busca gráfico de despesas por categoria
  Future<({Failure? failure, DashboardChart? chart})> getExpensesByCategory({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Busca gráfico de receitas vs despesas
  Future<({Failure? failure, DashboardChart? chart})> getIncomeVsExpenses({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Busca evolução do saldo (últimos meses)
  Future<({Failure? failure, DashboardChart? chart})> getBalanceEvolution({
    required int monthsBack,
  });

  /// Busca transações recentes
  Future<({Failure? failure, List<RecentTransaction> transactions})>
  getRecentTransactions({required int limit});

  /// Busca transações do dia
  Future<({Failure? failure, List<RecentTransaction> transactions})>
  getTodayTransactions();

  /// Busca meta vs realizado do mês
  Future<({Failure? failure, Map<String, double> data})> getMonthlyBudget({
    required DateTime month,
  });
}
