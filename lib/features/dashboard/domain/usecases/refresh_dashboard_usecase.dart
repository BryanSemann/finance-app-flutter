import '../../../../core/usecases/usecase.dart';
import '../repositories/dashboard_repository.dart';

/// Use case para atualizar os dados do dashboard
class RefreshDashboard implements UseCase<bool, NoParams> {
  final DashboardRepository repository;

  RefreshDashboard(this.repository);

  @override
  Future<bool> call(NoParams params) async {
    try {
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));

      // Busca novos dados (força refresh ignorando cache)
      await repository.getFinancialSummary(month: now);
      await repository.getDashboardCharts(
        startDate: thirtyDaysAgo,
        endDate: now,
      );
      await repository.getRecentTransactions(limit: 10);

      return true;
    } catch (e) {
      return false;
    }
  }
}
