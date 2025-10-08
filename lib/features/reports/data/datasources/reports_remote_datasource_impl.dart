import '../../../../core/network/dio_client.dart';
import '../../domain/entities/report.dart';
import '../models/report_model.dart';
import 'reports_remote_datasource.dart';

/// Implementação da fonte de dados remota para relatórios
class ReportsRemoteDataSourceImpl implements ReportsRemoteDataSource {
  const ReportsRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<ReportModel> generateExpenseReport({
    required DateTime startDate,
    required DateTime endDate,
    List<String>? categories,
  }) async {
    final response = await _dioClient.post(
      '/reports/expenses',
      data: {
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        if (categories != null) 'categories': categories,
      },
    );

    return ReportModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ReportModel> generateIncomeReport({
    required DateTime startDate,
    required DateTime endDate,
    List<String>? categories,
  }) async {
    final response = await _dioClient.post(
      '/reports/income',
      data: {
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        if (categories != null) 'categories': categories,
      },
    );

    return ReportModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ReportModel> generateCategoryReport({
    required DateTime startDate,
    required DateTime endDate,
    required ReportType type,
  }) async {
    final response = await _dioClient.post(
      '/reports/categories',
      data: {
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'type': type.value,
      },
    );

    return ReportModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<ReportModel>> getReportsHistory({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dioClient.get(
      '/reports/history',
      queryParameters: {'page': page, 'limit': limit},
    );

    final data = response.data as Map<String, dynamic>;
    final reportsJson = data['reports'] as List<dynamic>;

    return reportsJson
        .map((json) => ReportModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> deleteReport(String reportId) async {
    await _dioClient.delete('/reports/$reportId');
  }
}
