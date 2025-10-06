import 'package:finance_app/app/shared/repositories/transaction_repository.dart';
import 'package:flutter/foundation.dart';

class HomeController extends ChangeNotifier {
  final TransactionRepository _transactionRepository;

  HomeController(this._transactionRepository);

  double _totalBalance = 0.0;
  double get totalBalance => _totalBalance;

  double _monthlyIncome = 0.0;
  double get monthlyIncome => _monthlyIncome;

  double _monthlyExpenses = 0.0;
  double get monthlyExpenses => _monthlyExpenses;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Buscar resumo financeiro da API
      final summary = await _transactionRepository.getFinancialSummary(
        month: DateTime.now(),
      );

      // Extrair dados do resumo retornado pela API
      _totalBalance = summary['total_balance']?.toDouble() ?? 0.0;
      _monthlyIncome = summary['monthly_income']?.toDouble() ?? 0.0;
      _monthlyExpenses = summary['monthly_expenses']?.toDouble() ?? 0.0;
    } catch (e) {
      debugPrint('Erro ao carregar dados: $e');
      // Em caso de erro, manter valores zerados ou usar cache local
      _totalBalance = 0.0;
      _monthlyIncome = 0.0;
      _monthlyExpenses = 0.0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void navigateToTransactions() {
    // Modular.to.pushNamed('/transactions');
  }

  void navigateToReports() {
    // Modular.to.pushNamed('/reports');
  }
}
