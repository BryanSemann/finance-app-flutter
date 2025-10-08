import '../entities/report.dart';

/// Repositório abstrato para operações relacionadas a relatórios
/// Segue os princípios do Clean Architecture
abstract class ReportsRepository {
  /// Gera um relatório de despesas para o período especificado
  Future<Report> generateExpenseReport({
    required DateTime startDate,
    required DateTime endDate,
    List<String>? categories,
  });

  /// Gera um relatório de receitas para o período especificado
  Future<Report> generateIncomeReport({
    required DateTime startDate,
    required DateTime endDate,
    List<String>? categories,
  });

  /// Gera um relatório de gastos por categoria
  Future<Report> generateCategoryReport({
    required DateTime startDate,
    required DateTime endDate,
    required ReportType type,
  });

  /// Obtém histórico de relatórios gerados
  Future<List<Report>> getReportsHistory({int page = 1, int limit = 20});

  /// Salva um relatório no histórico local
  Future<void> saveReportToHistory(Report report);

  /// Remove um relatório do histórico
  Future<void> deleteReport(String reportId);
}
