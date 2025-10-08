import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/financial_summary.dart';
import '../repositories/dashboard_repository.dart';

/// Parâmetros para buscar resumo financeiro
class GetFinancialSummaryParams {
  final DateTime month;

  const GetFinancialSummaryParams({required this.month});
}

/// Use case para buscar resumo financeiro do mês
class GetFinancialSummaryUseCase
    implements
        UseCase<
          ({Failure? failure, FinancialSummary? summary}),
          GetFinancialSummaryParams
        > {
  final DashboardRepository _repository;

  GetFinancialSummaryUseCase(this._repository);

  @override
  Future<({Failure? failure, FinancialSummary? summary})> call(
    GetFinancialSummaryParams params,
  ) async {
    return await _repository.getFinancialSummary(month: params.month);
  }
}
