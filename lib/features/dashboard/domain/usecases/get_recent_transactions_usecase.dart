import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/recent_transaction.dart';
import '../repositories/dashboard_repository.dart';

/// Parâmetros para buscar transações recentes
class GetRecentTransactionsParams {
  final int limit;

  const GetRecentTransactionsParams({required this.limit});
}

/// Use case para buscar transações recentes
class GetRecentTransactionsUseCase
    implements
        UseCase<
          ({Failure? failure, List<RecentTransaction> transactions}),
          GetRecentTransactionsParams
        > {
  final DashboardRepository _repository;

  GetRecentTransactionsUseCase(this._repository);

  @override
  Future<({Failure? failure, List<RecentTransaction> transactions})> call(
    GetRecentTransactionsParams params,
  ) async {
    return await _repository.getRecentTransactions(limit: params.limit);
  }
}

/// Use case para buscar transações do dia
class GetTodayTransactionsUseCase
    implements
        UseCase<
          ({Failure? failure, List<RecentTransaction> transactions}),
          NoParams
        > {
  final DashboardRepository _repository;

  GetTodayTransactionsUseCase(this._repository);

  @override
  Future<({Failure? failure, List<RecentTransaction> transactions})> call(
    NoParams params,
  ) async {
    return await _repository.getTodayTransactions();
  }
}
