import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/dashboard_chart.dart';
import '../repositories/dashboard_repository.dart';

/// Parâmetros para buscar gráfico de despesas por categoria
class GetExpensesByCategoryParams {
  final DateTime startDate;
  final DateTime endDate;

  const GetExpensesByCategoryParams({
    required this.startDate,
    required this.endDate,
  });
}

/// Use case para buscar gráfico de despesas por categoria
class GetExpensesByCategoryUseCase
    implements
        UseCase<
          ({Failure? failure, DashboardChart? chart}),
          GetExpensesByCategoryParams
        > {
  final DashboardRepository _repository;

  GetExpensesByCategoryUseCase(this._repository);

  @override
  Future<({Failure? failure, DashboardChart? chart})> call(
    GetExpensesByCategoryParams params,
  ) async {
    return await _repository.getExpensesByCategory(
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}

/// Parâmetros para buscar evolução do saldo
class GetBalanceEvolutionParams {
  final int monthsBack;

  const GetBalanceEvolutionParams({required this.monthsBack});
}

/// Use case para buscar evolução do saldo
class GetBalanceEvolutionUseCase
    implements
        UseCase<
          ({Failure? failure, DashboardChart? chart}),
          GetBalanceEvolutionParams
        > {
  final DashboardRepository _repository;

  GetBalanceEvolutionUseCase(this._repository);

  @override
  Future<({Failure? failure, DashboardChart? chart})> call(
    GetBalanceEvolutionParams params,
  ) async {
    return await _repository.getBalanceEvolution(monthsBack: params.monthsBack);
  }
}
