import '../../../../core/usecases/usecase.dart';
import '../entities/dashboard_chart.dart';
import '../repositories/dashboard_repository.dart';

/// Parâmetros para buscar gráficos do cache
class GetCachedDashboardChartsParams {
  final DateTime startDate;
  final DateTime endDate;

  GetCachedDashboardChartsParams({
    required this.startDate,
    required this.endDate,
  });
}

/// Use case para buscar gráficos do dashboard do cache
class GetCachedDashboardCharts
    implements UseCase<List<DashboardChart>, GetCachedDashboardChartsParams> {
  final DashboardRepository repository;

  GetCachedDashboardCharts(this.repository);

  @override
  Future<List<DashboardChart>> call(
    GetCachedDashboardChartsParams params,
  ) async {
    final result = await repository.getDashboardCharts(
      startDate: params.startDate,
      endDate: params.endDate,
    );
    return result.charts;
  }
}
