import '../entities/report.dart';
import '../repositories/reports_repository.dart';

/// Caso de uso para gerar relatório por categorias
class GenerateCategoryReportUseCase {
  const GenerateCategoryReportUseCase(this._repository);

  final ReportsRepository _repository;

  /// Executa a geração do relatório por categorias
  Future<Report> call({
    required DateTime startDate,
    required DateTime endDate,
    required ReportType type,
  }) async {
    if (startDate.isAfter(endDate)) {
      throw ArgumentError('Data inicial não pode ser posterior à data final');
    }

    if (type != ReportType.expense && type != ReportType.income) {
      throw ArgumentError('Tipo de relatório deve ser expense ou income');
    }

    final report = await _repository.generateCategoryReport(
      startDate: startDate,
      endDate: endDate,
      type: type,
    );

    // Salva no histórico automaticamente
    await _repository.saveReportToHistory(report);

    return report;
  }
}
