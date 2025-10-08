import '../models/financial_summary_model.dart';
import '../models/dashboard_chart_model.dart';
import '../models/recent_transaction_model.dart';

/// Interface para data source local do dashboard
abstract class DashboardLocalDataSource {
  /// Cache do resumo financeiro
  Future<void> cacheFinancialSummary(
    FinancialSummaryModel summary,
    DateTime month,
  );
  Future<FinancialSummaryModel?> getCachedFinancialSummary(DateTime month);

  /// Cache de gráficos
  Future<void> cacheDashboardCharts(
    List<DashboardChartModel> charts,
    String key,
  );
  Future<List<DashboardChartModel>?> getCachedDashboardCharts(String key);

  /// Cache de transações recentes
  Future<void> cacheRecentTransactions(
    List<RecentTransactionModel> transactions,
  );
  Future<List<RecentTransactionModel>?> getCachedRecentTransactions();

  /// Limpar cache
  Future<void> clearCache();
  Future<void> clearExpiredCache();
}
