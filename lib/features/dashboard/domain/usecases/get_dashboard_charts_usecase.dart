import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/dashboard_chart.dart';
import '../repositories/dashboard_repository.dart';

/// Parâmetros para buscar gráficos do dashboard
class GetDashboardChartsParams {
  final DateTime startDate;
  final DateTime endDate;

  const GetDashboardChartsParams({
    required this.startDate,
    required this.endDate,
  });
}

/// Use case para buscar gráficos do dashboard
class GetDashboardChartsUseCase
    implements
        UseCase<
          ({Failure? failure, List<DashboardChart> charts}),
          GetDashboardChartsParams
        > {
  final DashboardRepository _repository;

  GetDashboardChartsUseCase(this._repository);

  @override
  Future<({Failure? failure, List<DashboardChart> charts})> call(
    GetDashboardChartsParams params,
  ) async {
    return await _repository.getDashboardCharts(
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}
