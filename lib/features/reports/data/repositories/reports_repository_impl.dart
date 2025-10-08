import 'package:flutter/foundation.dart';
import '../../domain/entities/report.dart';
import '../../domain/repositories/reports_repository.dart';
import '../datasources/reports_remote_datasource.dart';
import '../models/report_model.dart';
import '../../../../core/storage/local_storage.dart';

/// Implementação do repositório de relatórios
class ReportsRepositoryImpl implements ReportsRepository {
  const ReportsRepositoryImpl({
    required this.remoteDataSource,
    required this.localStorage,
  });

  final ReportsRemoteDataSource remoteDataSource;
  final LocalStorage localStorage;

  @override
  Future<Report> generateExpenseReport({
    required DateTime startDate,
    required DateTime endDate,
    List<String>? categories,
  }) async {
    return await remoteDataSource.generateExpenseReport(
      startDate: startDate,
      endDate: endDate,
      categories: categories,
    );
  }

  @override
  Future<Report> generateIncomeReport({
    required DateTime startDate,
    required DateTime endDate,
    List<String>? categories,
  }) async {
    return await remoteDataSource.generateIncomeReport(
      startDate: startDate,
      endDate: endDate,
      categories: categories,
    );
  }

  @override
  Future<Report> generateCategoryReport({
    required DateTime startDate,
    required DateTime endDate,
    required ReportType type,
  }) async {
    return await remoteDataSource.generateCategoryReport(
      startDate: startDate,
      endDate: endDate,
      type: type,
    );
  }

  @override
  Future<List<Report>> getReportsHistory({int page = 1, int limit = 20}) async {
    try {
      // Tenta buscar do servidor primeiro
      final reports = await remoteDataSource.getReportsHistory(
        page: page,
        limit: limit,
      );

      // Salva no cache local
      await _cacheReports(reports);

      return reports;
    } catch (e) {
      // Se falhar, busca do cache local
      return await _getCachedReports(page: page, limit: limit);
    }
  }

  @override
  Future<void> saveReportToHistory(Report report) async {
    try {
      // Salva localmente primeiro
      await _saveReportLocally(report);
    } catch (e) {
      // Log do erro, mas não falha a operação
      if (kDebugMode) {
        print('Erro ao salvar relatório no histórico: $e');
      }
    }
  }

  @override
  Future<void> deleteReport(String reportId) async {
    await remoteDataSource.deleteReport(reportId);
    await _deleteReportLocally(reportId);
  }

  /// Cache dos relatórios localmente
  Future<void> _cacheReports(List<ReportModel> reports) async {
    final reportsJson = reports.map((report) => report.toJson()).toList();
    await localStorage.setStringList(
      'cached_reports',
      reportsJson.map((json) => json.toString()).toList(),
    );
  }

  /// Busca relatórios do cache local
  Future<List<Report>> _getCachedReports({int page = 1, int limit = 20}) async {
    try {
      final cachedData = await localStorage.getStringList('cached_reports');
      if (cachedData == null) return [];

      return cachedData
          .map(
            (jsonString) => ReportModel.fromJson(
              Map<String, dynamic>.from(Uri.parse(jsonString).queryParameters),
            ),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Salva um relatório localmente
  Future<void> _saveReportLocally(Report report) async {
    final reportModel = report is ReportModel
        ? report
        : ReportModel(
            id: report.id,
            title: report.title,
            type: report.type,
            startDate: report.startDate,
            endDate: report.endDate,
            totalAmount: report.totalAmount,
            transactionCount: report.transactionCount,
            categories: report.categories,
            createdAt: report.createdAt,
          );

    // Obtém lista atual
    final currentReports = await _getCachedReports();
    final updatedReports = [...currentReports, reportModel]
        .map(
          (r) => r is ReportModel
              ? r
              : ReportModel(
                  id: r.id,
                  title: r.title,
                  type: r.type,
                  startDate: r.startDate,
                  endDate: r.endDate,
                  totalAmount: r.totalAmount,
                  transactionCount: r.transactionCount,
                  categories: r.categories,
                  createdAt: r.createdAt,
                ),
        )
        .toList();

    await _cacheReports(updatedReports);
  }

  /// Remove um relatório localmente
  Future<void> _deleteReportLocally(String reportId) async {
    final currentReports = await _getCachedReports();
    final filteredReports = currentReports
        .where((report) => report.id != reportId)
        .map(
          (r) => r is ReportModel
              ? r
              : ReportModel(
                  id: r.id,
                  title: r.title,
                  type: r.type,
                  startDate: r.startDate,
                  endDate: r.endDate,
                  totalAmount: r.totalAmount,
                  transactionCount: r.transactionCount,
                  categories: r.categories,
                  createdAt: r.createdAt,
                ),
        )
        .toList();

    await _cacheReports(filteredReports);
  }
}
