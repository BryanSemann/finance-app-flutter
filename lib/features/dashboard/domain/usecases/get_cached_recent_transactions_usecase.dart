import '../../../../core/usecases/usecase.dart';
import '../entities/recent_transaction.dart';
import '../repositories/dashboard_repository.dart';

/// Parâmetros para buscar transações recentes do cache
class GetCachedRecentTransactionsParams {
  final int limit;

  GetCachedRecentTransactionsParams({required this.limit});
}

/// Use case para buscar transações recentes do cache
class GetCachedRecentTransactions
    implements
        UseCase<List<RecentTransaction>, GetCachedRecentTransactionsParams> {
  final DashboardRepository repository;

  GetCachedRecentTransactions(this.repository);

  @override
  Future<List<RecentTransaction>> call(
    GetCachedRecentTransactionsParams params,
  ) async {
    final result = await repository.getRecentTransactions(limit: params.limit);
    return result.transactions;
  }
}
