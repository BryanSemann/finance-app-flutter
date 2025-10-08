import '../../../../core/usecases/usecase.dart';
import '../entities/financial_summary.dart';
import '../repositories/dashboard_repository.dart';

/// Parâmetros para buscar resumo financeiro em cache
class GetCachedFinancialSummaryParams {
  final DateTime month;

  GetCachedFinancialSummaryParams({required this.month});
}

/// Use case para buscar resumo financeiro do cache
class GetCachedFinancialSummary
    implements UseCase<FinancialSummary?, GetCachedFinancialSummaryParams> {
  final DashboardRepository repository;

  GetCachedFinancialSummary(this.repository);

  @override
  Future<FinancialSummary?> call(GetCachedFinancialSummaryParams params) async {
    final result = await repository.getFinancialSummary(month: params.month);
    return result.summary;
  }
}
