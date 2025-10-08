import '../entities/report.dart';
import '../repositories/reports_repository.dart';

/// Caso de uso para gerar relatório de despesas
class GenerateExpenseReportUseCase {
  const GenerateExpenseReportUseCase(this._repository);

  final ReportsRepository _repository;

  /// Executa a geração do relatório de despesas
  Future<Report> call({
    required DateTime startDate,
    required DateTime endDate,
    List<String>? categories,
  }) async {
    if (startDate.isAfter(endDate)) {
      throw ArgumentError('Data inicial não pode ser posterior à data final');
    }

    final report = await _repository.generateExpenseReport(
      startDate: startDate,
      endDate: endDate,
      categories: categories,
    );

    // Salva no histórico automaticamente
    await _repository.saveReportToHistory(report);

    return report;
  }
}
