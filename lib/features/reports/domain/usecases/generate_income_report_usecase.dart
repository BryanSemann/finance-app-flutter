import '../entities/report.dart';
import '../repositories/reports_repository.dart';

/// Caso de uso para gerar relatório de receitas
class GenerateIncomeReportUseCase {
  const GenerateIncomeReportUseCase(this._repository);

  final ReportsRepository _repository;

  /// Executa a geração do relatório de receitas
  Future<Report> call({
    required DateTime startDate,
    required DateTime endDate,
    List<String>? categories,
  }) async {
    if (startDate.isAfter(endDate)) {
      throw ArgumentError('Data inicial não pode ser posterior à data final');
    }

    final report = await _repository.generateIncomeReport(
      startDate: startDate,
      endDate: endDate,
      categories: categories,
    );

    // Salva no histórico automaticamente
    await _repository.saveReportToHistory(report);

    return report;
  }
}
