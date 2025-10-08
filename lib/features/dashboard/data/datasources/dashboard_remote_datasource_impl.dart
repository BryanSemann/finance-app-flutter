import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/financial_summary_model.dart';
import '../models/dashboard_chart_model.dart';
import '../models/recent_transaction_model.dart';
import 'dashboard_remote_datasource.dart';

/// Implementação do data source remoto do dashboard
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final DioClient _client;

  DashboardRemoteDataSourceImpl(this._client);

  @override
  Future<FinancialSummaryModel> getFinancialSummary({
    required DateTime month,
  }) async {
    try {
      final response = await _client.get(
        '${ApiEndpoints.dashboard}/summary',
        queryParameters: {
          'month': '${month.year}-${month.month.toString().padLeft(2, '0')}',
        },
      );

      return FinancialSummaryModel.fromJson(response.data['data']);
    } catch (e) {
      throw ServerException(message: 'Erro ao buscar resumo financeiro: $e');
    }
  }

  @override
  Future<FinancialSummaryModel> getFinancialSummaryByPeriod({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _client.get(
        '${ApiEndpoints.dashboard}/summary-period',
        queryParameters: {
          'start_date': startDate.toIso8601String().split('T')[0],
          'end_date': endDate.toIso8601String().split('T')[0],
        },
      );

      return FinancialSummaryModel.fromJson(response.data['data']);
    } catch (e) {
      throw ServerException(message: 'Erro ao buscar resumo do período: $e');
    }
  }

  @override
  Future<List<DashboardChartModel>> getDashboardCharts({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _client.get(
        '${ApiEndpoints.dashboard}/charts',
        queryParameters: {
          'start_date': startDate.toIso8601String().split('T')[0],
          'end_date': endDate.toIso8601String().split('T')[0],
        },
      );

      final List<dynamic> chartsJson = response.data['data'];
      return chartsJson
          .map((json) => DashboardChartModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(message: 'Erro ao buscar gráficos: $e');
    }
  }

  @override
  Future<DashboardChartModel> getExpensesByCategory({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _client.get(
        '${ApiEndpoints.dashboard}/expenses-by-category',
        queryParameters: {
          'start_date': startDate.toIso8601String().split('T')[0],
          'end_date': endDate.toIso8601String().split('T')[0],
        },
      );

      return DashboardChartModel.fromJson(response.data['data']);
    } catch (e) {
      throw ServerException(
        message: 'Erro ao buscar despesas por categoria: $e',
      );
    }
  }

  @override
  Future<DashboardChartModel> getIncomeVsExpenses({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _client.get(
        '${ApiEndpoints.dashboard}/income-vs-expenses',
        queryParameters: {
          'start_date': startDate.toIso8601String().split('T')[0],
          'end_date': endDate.toIso8601String().split('T')[0],
        },
      );

      return DashboardChartModel.fromJson(response.data['data']);
    } catch (e) {
      throw ServerException(message: 'Erro ao buscar receitas vs despesas: $e');
    }
  }

  @override
  Future<DashboardChartModel> getBalanceEvolution({
    required int monthsBack,
  }) async {
    try {
      final response = await _client.get(
        '${ApiEndpoints.dashboard}/balance-evolution',
        queryParameters: {'months_back': monthsBack},
      );

      return DashboardChartModel.fromJson(response.data['data']);
    } catch (e) {
      throw ServerException(message: 'Erro ao buscar evolução do saldo: $e');
    }
  }

  @override
  Future<List<RecentTransactionModel>> getRecentTransactions({
    required int limit,
  }) async {
    try {
      final response = await _client.get(
        '${ApiEndpoints.dashboard}/recent-transactions',
        queryParameters: {'limit': limit},
      );

      final List<dynamic> transactionsJson = response.data['data'];
      return transactionsJson
          .map((json) => RecentTransactionModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(message: 'Erro ao buscar transações recentes: $e');
    }
  }

  @override
  Future<List<RecentTransactionModel>> getTodayTransactions() async {
    try {
      final response = await _client.get(
        '${ApiEndpoints.dashboard}/today-transactions',
      );

      final List<dynamic> transactionsJson = response.data['data'];
      return transactionsJson
          .map((json) => RecentTransactionModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(message: 'Erro ao buscar transações do dia: $e');
    }
  }

  @override
  Future<Map<String, double>> getMonthlyBudget({
    required DateTime month,
  }) async {
    try {
      final response = await _client.get(
        '${ApiEndpoints.dashboard}/monthly-budget',
        queryParameters: {
          'month': '${month.year}-${month.month.toString().padLeft(2, '0')}',
        },
      );

      final Map<String, dynamic> data = response.data['data'];
      return data.map((key, value) => MapEntry(key, (value as num).toDouble()));
    } catch (e) {
      throw ServerException(message: 'Erro ao buscar orçamento mensal: $e');
    }
  }
}
