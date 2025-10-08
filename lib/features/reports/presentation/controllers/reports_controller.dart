import 'package:flutter/foundation.dart';
import '../../domain/entities/report.dart';
import '../../domain/usecases/generate_expense_report_usecase.dart';
import '../../domain/usecases/generate_income_report_usecase.dart';
import '../../domain/usecases/generate_category_report_usecase.dart';

/// Controller para gerenciar os relatórios usando Clean Architecture
class ReportsController extends ChangeNotifier {
  ReportsController({
    required this.generateExpenseReportUseCase,
    required this.generateIncomeReportUseCase,
    required this.generateCategoryReportUseCase,
  });

  final GenerateExpenseReportUseCase generateExpenseReportUseCase;
  final GenerateIncomeReportUseCase generateIncomeReportUseCase;
  final GenerateCategoryReportUseCase generateCategoryReportUseCase;

  bool _isLoading = false;
  String? _errorMessage;
  Report? _currentReport;
  List<Report> _reportsHistory = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Report? get currentReport => _currentReport;
  List<Report> get reportsHistory => List.unmodifiable(_reportsHistory);

  /// Gera um relatório de despesas
  Future<void> generateExpenseReport({
    required DateTime startDate,
    required DateTime endDate,
    List<String>? categories,
  }) async {
    await _executeWithLoading(() async {
      _currentReport = await generateExpenseReportUseCase(
        startDate: startDate,
        endDate: endDate,
        categories: categories,
      );
      _addToHistory(_currentReport!);
    });
  }

  /// Gera um relatório de receitas
  Future<void> generateIncomeReport({
    required DateTime startDate,
    required DateTime endDate,
    List<String>? categories,
  }) async {
    await _executeWithLoading(() async {
      _currentReport = await generateIncomeReportUseCase(
        startDate: startDate,
        endDate: endDate,
        categories: categories,
      );
      _addToHistory(_currentReport!);
    });
  }

  /// Gera um relatório por categorias
  Future<void> generateCategoryReport({
    required DateTime startDate,
    required DateTime endDate,
    required ReportType type,
  }) async {
    await _executeWithLoading(() async {
      _currentReport = await generateCategoryReportUseCase(
        startDate: startDate,
        endDate: endDate,
        type: type,
      );
      _addToHistory(_currentReport!);
    });
  }

  /// Limpa o relatório atual
  void clearCurrentReport() {
    _currentReport = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Limpa mensagens de erro
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Adiciona um relatório ao histórico
  void _addToHistory(Report report) {
    _reportsHistory = [report, ..._reportsHistory];
  }

  /// Executa uma operação com controle de loading e erro
  Future<void> _executeWithLoading(Future<void> Function() operation) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      await operation();
    } catch (e) {
      _errorMessage = e.toString();
      _currentReport = null;
    } finally {
      _setLoading(false);
    }
  }

  /// Controla o estado de loading
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
