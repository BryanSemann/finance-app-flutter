import '../../domain/entities/report.dart';
import '../models/report_model.dart';

/// Fonte de dados remota para relatórios
abstract class ReportsRemoteDataSource {
  /// Gera um relatório de despesas via API
  Future<ReportModel> generateExpenseReport({
    required DateTime startDate,
    required DateTime endDate,
    List<String>? categories,
  });

  /// Gera um relatório de receitas via API
  Future<ReportModel> generateIncomeReport({
    required DateTime startDate,
    required DateTime endDate,
    List<String>? categories,
  });

  /// Gera um relatório por categorias via API
  Future<ReportModel> generateCategoryReport({
    required DateTime startDate,
    required DateTime endDate,
    required ReportType type,
  });

  /// Obtém histórico de relatórios via API
  Future<List<ReportModel>> getReportsHistory({int page = 1, int limit = 20});

  /// Remove um relatório via API
  Future<void> deleteReport(String reportId);
}
