import 'package:flutter/foundation.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/domain.dart';

/// Estados de carregamento do dashboard
enum DashboardLoadingState {
  idle,
  loadingInitial,
  loadingSummary,
  loadingCharts,
  loadingTransactions,
  refreshing,
}

/// Controlador de estado para o dashboard
class DashboardController extends ChangeNotifier {
  final GetFinancialSummaryUseCase _getFinancialSummaryUseCase;
  final GetDashboardChartsUseCase _getDashboardChartsUseCase;
  final GetRecentTransactionsUseCase _getRecentTransactionsUseCase;
  final GetTodayTransactionsUseCase _getTodayTransactionsUseCase;
  final GetExpensesByCategoryUseCase _getExpensesByCategoryUseCase;
  final GetBalanceEvolutionUseCase _getBalanceEvolutionUseCase;

  DashboardController({
    required GetFinancialSummaryUseCase getFinancialSummaryUseCase,
    required GetDashboardChartsUseCase getDashboardChartsUseCase,
    required GetRecentTransactionsUseCase getRecentTransactionsUseCase,
    required GetTodayTransactionsUseCase getTodayTransactionsUseCase,
    required GetExpensesByCategoryUseCase getExpensesByCategoryUseCase,
    required GetBalanceEvolutionUseCase getBalanceEvolutionUseCase,
  }) : _getFinancialSummaryUseCase = getFinancialSummaryUseCase,
       _getDashboardChartsUseCase = getDashboardChartsUseCase,
       _getRecentTransactionsUseCase = getRecentTransactionsUseCase,
       _getTodayTransactionsUseCase = getTodayTransactionsUseCase,
       _getExpensesByCategoryUseCase = getExpensesByCategoryUseCase,
       _getBalanceEvolutionUseCase = getBalanceEvolutionUseCase;

  // Estados privados
  DashboardLoadingState _loadingState = DashboardLoadingState.idle;
  FinancialSummary? _financialSummary;
  List<DashboardChart> _charts = [];
  List<RecentTransaction> _recentTransactions = [];
  List<RecentTransaction> _todayTransactions = [];
  DashboardChart? _expensesChart;
  DashboardChart? _balanceChart;
  Failure? _lastError;
  DateTime _currentMonth = DateTime.now();
  DateTime _chartsStartDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _chartsEndDate = DateTime.now();

  // Getters
  DashboardLoadingState get loadingState => _loadingState;
  FinancialSummary? get financialSummary => _financialSummary;
  List<DashboardChart> get charts => _charts;
  List<RecentTransaction> get recentTransactions => _recentTransactions;
  List<RecentTransaction> get todayTransactions => _todayTransactions;
  DashboardChart? get expensesChart => _expensesChart;
  DashboardChart? get balanceChart => _balanceChart;
  Failure? get lastError => _lastError;
  DateTime get currentMonth => _currentMonth;
  DateTime get chartsStartDate => _chartsStartDate;
  DateTime get chartsEndDate => _chartsEndDate;

  bool get isLoading => _loadingState != DashboardLoadingState.idle;
  bool get isLoadingInitial =>
      _loadingState == DashboardLoadingState.loadingInitial;
  bool get isRefreshing => _loadingState == DashboardLoadingState.refreshing;
  bool get hasData => _financialSummary != null;
  bool get hasError => _lastError != null;

  /// Limpa o erro atual
  void clearError() {
    _lastError = null;
    notifyListeners();
  }

  /// Altera o mês atual
  void changeMonth(DateTime newMonth) {
    if (_currentMonth != newMonth) {
      _currentMonth = newMonth;
      loadFinancialSummary();
    }
  }

  /// Altera o período dos gráficos
  void changeChartsPeriod(DateTime startDate, DateTime endDate) {
    if (_chartsStartDate != startDate || _chartsEndDate != endDate) {
      _chartsStartDate = startDate;
      _chartsEndDate = endDate;
      loadCharts();
    }
  }

  /// Carregamento inicial completo do dashboard
  Future<void> loadDashboardData() async {
    if (_loadingState == DashboardLoadingState.loadingInitial) return;

    _loadingState = DashboardLoadingState.loadingInitial;
    _lastError = null;
    notifyListeners();

    try {
      // Carregar dados em paralelo
      await Future.wait([
        loadFinancialSummary(notify: false),
        loadRecentTransactions(notify: false),
        loadTodayTransactions(notify: false),
        loadCharts(notify: false),
      ]);
    } finally {
      _loadingState = DashboardLoadingState.idle;
      notifyListeners();
    }
  }

  /// Atualiza todos os dados (pull-to-refresh)
  Future<void> refreshDashboard() async {
    if (_loadingState == DashboardLoadingState.refreshing) return;

    _loadingState = DashboardLoadingState.refreshing;
    _lastError = null;
    notifyListeners();

    try {
      await Future.wait([
        loadFinancialSummary(notify: false),
        loadRecentTransactions(notify: false),
        loadTodayTransactions(notify: false),
        loadCharts(notify: false),
      ]);
    } finally {
      _loadingState = DashboardLoadingState.idle;
      notifyListeners();
    }
  }

  /// Carrega resumo financeiro
  Future<void> loadFinancialSummary({bool notify = true}) async {
    if (!notify && _loadingState == DashboardLoadingState.idle) {
      _loadingState = DashboardLoadingState.loadingSummary;
    }

    try {
      final result = await _getFinancialSummaryUseCase.call(
        GetFinancialSummaryParams(month: _currentMonth),
      );

      if (result.failure != null) {
        _lastError = result.failure;
      } else {
        _financialSummary = result.summary;
        _lastError = null;
      }
    } catch (e) {
      _lastError = UnexpectedFailure(
        message: 'Erro inesperado ao carregar resumo: $e',
      );
    }

    if (notify) {
      _loadingState = DashboardLoadingState.idle;
      notifyListeners();
    }
  }

  /// Carrega gráficos do dashboard
  Future<void> loadCharts({bool notify = true}) async {
    if (!notify && _loadingState == DashboardLoadingState.idle) {
      _loadingState = DashboardLoadingState.loadingCharts;
    }

    try {
      // Carregar gráficos principais
      final chartsResult = await _getDashboardChartsUseCase.call(
        GetDashboardChartsParams(
          startDate: _chartsStartDate,
          endDate: _chartsEndDate,
        ),
      );

      if (chartsResult.failure == null) {
        _charts = chartsResult.charts;
      }

      // Carregar gráfico de despesas por categoria
      final expensesResult = await _getExpensesByCategoryUseCase.call(
        GetExpensesByCategoryParams(
          startDate: _chartsStartDate,
          endDate: _chartsEndDate,
        ),
      );

      if (expensesResult.failure == null) {
        _expensesChart = expensesResult.chart;
      }

      // Carregar evolução do saldo
      final balanceResult = await _getBalanceEvolutionUseCase.call(
        const GetBalanceEvolutionParams(monthsBack: 6),
      );

      if (balanceResult.failure == null) {
        _balanceChart = balanceResult.chart;
      }

      // Se algum erro importante ocorreu
      if (chartsResult.failure != null) {
        _lastError = chartsResult.failure;
      } else if (expensesResult.failure != null) {
        _lastError = expensesResult.failure;
      } else if (balanceResult.failure != null) {
        _lastError = balanceResult.failure;
      }
    } catch (e) {
      _lastError = UnexpectedFailure(
        message: 'Erro inesperado ao carregar gráficos: $e',
      );
    }

    if (notify) {
      _loadingState = DashboardLoadingState.idle;
      notifyListeners();
    }
  }

  /// Carrega transações recentes
  Future<void> loadRecentTransactions({bool notify = true}) async {
    if (!notify && _loadingState == DashboardLoadingState.idle) {
      _loadingState = DashboardLoadingState.loadingTransactions;
    }

    try {
      final result = await _getRecentTransactionsUseCase.call(
        const GetRecentTransactionsParams(limit: 10),
      );

      if (result.failure != null) {
        _lastError = result.failure;
      } else {
        _recentTransactions = result.transactions;
      }
    } catch (e) {
      _lastError = UnexpectedFailure(
        message: 'Erro inesperado ao carregar transações: $e',
      );
    }

    if (notify) {
      _loadingState = DashboardLoadingState.idle;
      notifyListeners();
    }
  }

  /// Carrega transações de hoje
  Future<void> loadTodayTransactions({bool notify = true}) async {
    try {
      final result = await _getTodayTransactionsUseCase.call(const NoParams());

      if (result.failure == null) {
        _todayTransactions = result.transactions;
      }
    } catch (e) {
      // Erro silencioso para transações do dia, não é crítico
    }

    if (notify) {
      notifyListeners();
    }
  }

  /// Dados do dashboard para exibição rápida
  Map<String, dynamic> get dashboardSummary {
    return {
      'hasData': hasData,
      'totalBalance': _financialSummary?.totalBalance ?? 0.0,
      'monthlyIncome': _financialSummary?.monthlyIncome ?? 0.0,
      'monthlyExpenses': _financialSummary?.monthlyExpenses ?? 0.0,
      'recentTransactionsCount': _recentTransactions.length,
      'todayTransactionsCount': _todayTransactions.length,
      'chartsCount': _charts.length,
      'hasExpensesChart': _expensesChart != null,
      'hasBalanceChart': _balanceChart != null,
    };
  }

  /// Reset completo dos dados
  void reset() {
    _loadingState = DashboardLoadingState.idle;
    _financialSummary = null;
    _charts = [];
    _recentTransactions = [];
    _todayTransactions = [];
    _expensesChart = null;
    _balanceChart = null;
    _lastError = null;
    _currentMonth = DateTime.now();
    _chartsStartDate = DateTime.now().subtract(const Duration(days: 30));
    _chartsEndDate = DateTime.now();
    notifyListeners();
  }
}
