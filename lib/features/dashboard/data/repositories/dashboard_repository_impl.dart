import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/financial_summary.dart';
import '../../domain/entities/dashboard_chart.dart';
import '../../domain/entities/recent_transaction.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';
import '../datasources/dashboard_local_datasource.dart';

/// Implementação do repositório do dashboard
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;
  final DashboardLocalDataSource _localDataSource;

  DashboardRepositoryImpl({
    required DashboardRemoteDataSource remoteDataSource,
    required DashboardLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<({Failure? failure, FinancialSummary? summary})> getFinancialSummary({
    required DateTime month,
  }) async {
    try {
      // Tentar buscar do cache primeiro
      final cachedSummary = await _localDataSource.getCachedFinancialSummary(
        month,
      );
      if (cachedSummary != null) {
        return (failure: null, summary: cachedSummary.toEntity());
      }

      // Buscar da API
      final summaryModel = await _remoteDataSource.getFinancialSummary(
        month: month,
      );

      // Cachear o resultado
      await _localDataSource.cacheFinancialSummary(summaryModel, month);

      return (failure: null, summary: summaryModel.toEntity());
    } on NetworkException catch (e) {
      return (
        failure: NetworkFailure(message: e.message, code: e.code),
        summary: null,
      );
    } on ServerException catch (e) {
      return (
        failure: ServerFailure(message: e.message, code: e.code),
        summary: null,
      );
    } on CacheException catch (e) {
      // Se falhou no cache mas não na API, só logar o erro e continuar
      return (
        failure: CacheFailure(message: e.message, code: e.code),
        summary: null,
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(
          message: 'Erro inesperado ao buscar resumo: $e',
        ),
        summary: null,
      );
    }
  }

  @override
  Future<({Failure? failure, FinancialSummary? summary})>
  getFinancialSummaryByPeriod({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final summaryModel = await _remoteDataSource.getFinancialSummaryByPeriod(
        startDate: startDate,
        endDate: endDate,
      );

      return (failure: null, summary: summaryModel.toEntity());
    } on NetworkException catch (e) {
      return (
        failure: NetworkFailure(message: e.message, code: e.code),
        summary: null,
      );
    } on ServerException catch (e) {
      return (
        failure: ServerFailure(message: e.message, code: e.code),
        summary: null,
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(
          message: 'Erro inesperado ao buscar resumo do período: $e',
        ),
        summary: null,
      );
    }
  }

  @override
  Future<({Failure? failure, List<DashboardChart> charts})> getDashboardCharts({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final cacheKey =
          '${startDate.toIso8601String().split('T')[0]}_${endDate.toIso8601String().split('T')[0]}';

      // Tentar buscar do cache primeiro
      final cachedCharts = await _localDataSource.getCachedDashboardCharts(
        cacheKey,
      );
      if (cachedCharts != null) {
        return (
          failure: null,
          charts: cachedCharts.map((chart) => chart.toEntity()).toList(),
        );
      }

      // Buscar da API
      final chartsModels = await _remoteDataSource.getDashboardCharts(
        startDate: startDate,
        endDate: endDate,
      );

      // Cachear o resultado
      await _localDataSource.cacheDashboardCharts(chartsModels, cacheKey);

      return (
        failure: null,
        charts: chartsModels.map((chart) => chart.toEntity()).toList(),
      );
    } on NetworkException catch (e) {
      return (
        failure: NetworkFailure(message: e.message, code: e.code),
        charts: <DashboardChart>[],
      );
    } on ServerException catch (e) {
      return (
        failure: ServerFailure(message: e.message, code: e.code),
        charts: <DashboardChart>[],
      );
    } on CacheException catch (e) {
      return (
        failure: CacheFailure(message: e.message, code: e.code),
        charts: <DashboardChart>[],
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(
          message: 'Erro inesperado ao buscar gráficos: $e',
        ),
        charts: <DashboardChart>[],
      );
    }
  }

  @override
  Future<({Failure? failure, DashboardChart? chart})> getExpensesByCategory({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final chartModel = await _remoteDataSource.getExpensesByCategory(
        startDate: startDate,
        endDate: endDate,
      );

      return (failure: null, chart: chartModel.toEntity());
    } on NetworkException catch (e) {
      return (
        failure: NetworkFailure(message: e.message, code: e.code),
        chart: null,
      );
    } on ServerException catch (e) {
      return (
        failure: ServerFailure(message: e.message, code: e.code),
        chart: null,
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(
          message: 'Erro inesperado ao buscar despesas por categoria: $e',
        ),
        chart: null,
      );
    }
  }

  @override
  Future<({Failure? failure, DashboardChart? chart})> getIncomeVsExpenses({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final chartModel = await _remoteDataSource.getIncomeVsExpenses(
        startDate: startDate,
        endDate: endDate,
      );

      return (failure: null, chart: chartModel.toEntity());
    } on NetworkException catch (e) {
      return (
        failure: NetworkFailure(message: e.message, code: e.code),
        chart: null,
      );
    } on ServerException catch (e) {
      return (
        failure: ServerFailure(message: e.message, code: e.code),
        chart: null,
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(
          message: 'Erro inesperado ao buscar receitas vs despesas: $e',
        ),
        chart: null,
      );
    }
  }

  @override
  Future<({Failure? failure, DashboardChart? chart})> getBalanceEvolution({
    required int monthsBack,
  }) async {
    try {
      final chartModel = await _remoteDataSource.getBalanceEvolution(
        monthsBack: monthsBack,
      );

      return (failure: null, chart: chartModel.toEntity());
    } on NetworkException catch (e) {
      return (
        failure: NetworkFailure(message: e.message, code: e.code),
        chart: null,
      );
    } on ServerException catch (e) {
      return (
        failure: ServerFailure(message: e.message, code: e.code),
        chart: null,
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(
          message: 'Erro inesperado ao buscar evolução do saldo: $e',
        ),
        chart: null,
      );
    }
  }

  @override
  Future<({Failure? failure, List<RecentTransaction> transactions})>
  getRecentTransactions({required int limit}) async {
    try {
      // Tentar buscar do cache primeiro (apenas para limite padrão)
      if (limit <= 10) {
        final cachedTransactions = await _localDataSource
            .getCachedRecentTransactions();
        if (cachedTransactions != null && cachedTransactions.length >= limit) {
          return (
            failure: null,
            transactions: cachedTransactions
                .take(limit)
                .map((transaction) => transaction.toEntity())
                .toList(),
          );
        }
      }

      // Buscar da API
      final transactionsModels = await _remoteDataSource.getRecentTransactions(
        limit: limit,
      );

      // Cachear o resultado (apenas se for o limite padrão)
      if (limit <= 10) {
        await _localDataSource.cacheRecentTransactions(transactionsModels);
      }

      return (
        failure: null,
        transactions: transactionsModels
            .map((transaction) => transaction.toEntity())
            .toList(),
      );
    } on NetworkException catch (e) {
      return (
        failure: NetworkFailure(message: e.message, code: e.code),
        transactions: <RecentTransaction>[],
      );
    } on ServerException catch (e) {
      return (
        failure: ServerFailure(message: e.message, code: e.code),
        transactions: <RecentTransaction>[],
      );
    } on CacheException catch (e) {
      return (
        failure: CacheFailure(message: e.message, code: e.code),
        transactions: <RecentTransaction>[],
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(
          message: 'Erro inesperado ao buscar transações recentes: $e',
        ),
        transactions: <RecentTransaction>[],
      );
    }
  }

  @override
  Future<({Failure? failure, List<RecentTransaction> transactions})>
  getTodayTransactions() async {
    try {
      final transactionsModels = await _remoteDataSource.getTodayTransactions();

      return (
        failure: null,
        transactions: transactionsModels
            .map((transaction) => transaction.toEntity())
            .toList(),
      );
    } on NetworkException catch (e) {
      return (
        failure: NetworkFailure(message: e.message, code: e.code),
        transactions: <RecentTransaction>[],
      );
    } on ServerException catch (e) {
      return (
        failure: ServerFailure(message: e.message, code: e.code),
        transactions: <RecentTransaction>[],
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(
          message: 'Erro inesperado ao buscar transações do dia: $e',
        ),
        transactions: <RecentTransaction>[],
      );
    }
  }

  @override
  Future<({Failure? failure, Map<String, double> data})> getMonthlyBudget({
    required DateTime month,
  }) async {
    try {
      final data = await _remoteDataSource.getMonthlyBudget(month: month);

      return (failure: null, data: data);
    } on NetworkException catch (e) {
      return (
        failure: NetworkFailure(message: e.message, code: e.code),
        data: <String, double>{},
      );
    } on ServerException catch (e) {
      return (
        failure: ServerFailure(message: e.message, code: e.code),
        data: <String, double>{},
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(
          message: 'Erro inesperado ao buscar orçamento mensal: $e',
        ),
        data: <String, double>{},
      );
    }
  }
}
