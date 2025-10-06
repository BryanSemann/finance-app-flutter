import 'package:flutter/foundation.dart';
import '../../shared/models/transaction.dart';
import '../../shared/models/transaction_category.dart';
import '../../shared/repositories/transaction_repository.dart';

class TransactionsController extends ChangeNotifier {
  final TransactionRepository _repository;

  TransactionsController(this._repository);

  // Estado da lista
  List<Transaction> _transactions = [];
  List<Transaction> get transactions => _transactions;

  List<TransactionCategory> _categories = [];
  List<TransactionCategory> get categories => _categories;

  // Estados de carregamento
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  // Filtros ativos
  DateTime? _startDate;
  DateTime? get startDate => _startDate;

  DateTime? _endDate;
  DateTime? get endDate => _endDate;

  TransactionType? _filterType;
  TransactionType? get filterType => _filterType;

  String? _filterCategoryId;
  String? get filterCategoryId => _filterCategoryId;

  // Paginação
  int _currentPage = 1;
  bool _hasNextPage = true;
  final int _pageSize = 20;

  // Erro
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  // Resumo financeiro
  Map<String, dynamic>? _summary;
  Map<String, dynamic>? get summary => _summary;

  // Inicializar dados
  Future<void> initialize() async {
    await Future.wait([
      loadCategories(),
      loadTransactions(refresh: true),
      loadSummary(),
    ]);
  }

  // Carregar categorias
  Future<void> loadCategories() async {
    try {
      _categories = await _repository.getCategories();
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao carregar categorias: $e');
      // Usar categorias padrão em caso de erro
      _categories = TransactionCategory.allDefaultCategories;
      notifyListeners();
    }
  }

  // Carregar transações
  Future<void> loadTransactions({bool refresh = false}) async {
    if (refresh) {
      _isLoading = true;
      _currentPage = 1;
      _hasNextPage = true;
      _transactions.clear();
      _errorMessage = null;
    } else {
      if (!_hasNextPage || _isLoadingMore) return;
      _isLoadingMore = true;
    }

    notifyListeners();

    try {
      final newTransactions = await _repository.getTransactions(
        startDate: _startDate,
        endDate: _endDate,
        type: _filterType,
        categoryId: _filterCategoryId,
        page: _currentPage,
        limit: _pageSize,
      );

      if (refresh) {
        _transactions = newTransactions;
      } else {
        _transactions.addAll(newTransactions);
      }

      _hasNextPage = newTransactions.length == _pageSize;
      _currentPage++;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // Carregar resumo financeiro
  Future<void> loadSummary() async {
    try {
      _summary = await _repository.getSummary(
        startDate: _startDate,
        endDate: _endDate,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao carregar resumo: $e');
    }
  }

  // Criar nova transação
  Future<bool> createTransaction({
    required String description,
    required double amount,
    required TransactionType type,
    required String categoryId,
    DateTime? transactionDate,
    String? notes,
    bool isInstallment = false,
    int totalInstallments = 1,
    ValueInputType valueInputType = ValueInputType.total,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      Transaction newTransaction;

      if (isInstallment && totalInstallments > 1) {
        newTransaction = Transaction.installments(
          description: description,
          amount: amount,
          type: type,
          categoryId: categoryId,
          totalInstallments: totalInstallments,
          valueInputType: valueInputType,
          firstInstallmentDate: transactionDate,
          notes: notes,
        );
      } else {
        newTransaction = Transaction.simple(
          description: description,
          amount: amount,
          type: type,
          categoryId: categoryId,
          transactionDate: transactionDate,
          notes: notes,
        );
      }

      final createdTransaction = await _repository.createTransaction(
        newTransaction,
      );

      // Adicionar à lista local
      _transactions.insert(0, createdTransaction);

      // Recarregar resumo
      await loadSummary();

      return true;
    } catch (e) {
      _errorMessage = 'Erro ao criar transação: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Atualizar transação
  Future<bool> updateTransaction(Transaction transaction) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final updatedTransaction = await _repository.updateTransaction(
        transaction,
      );

      // Atualizar na lista local
      final index = _transactions.indexWhere((t) => t.id == transaction.id);
      if (index != -1) {
        _transactions[index] = updatedTransaction;
      }

      await loadSummary();

      return true;
    } catch (e) {
      _errorMessage = 'Erro ao atualizar transação: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Deletar transação
  Future<bool> deleteTransaction(String id) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _repository.deleteTransaction(id);

      // Remover da lista local
      _transactions.removeWhere((t) => t.id == id);

      await loadSummary();

      return true;
    } catch (e) {
      _errorMessage = 'Erro ao deletar transação: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Duplicar transação
  Future<bool> duplicateTransaction(String id) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final duplicatedTransaction = await _repository.duplicateTransaction(id);

      // Adicionar à lista local
      _transactions.insert(0, duplicatedTransaction);

      await loadSummary();

      return true;
    } catch (e) {
      _errorMessage = 'Erro ao duplicar transação: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Buscar transações
  Future<void> searchTransactions(String query) async {
    if (query.isEmpty) {
      await loadTransactions(refresh: true);
      return;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _transactions = await _repository.searchTransactions(query);
    } catch (e) {
      _errorMessage = 'Erro na busca: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Aplicar filtros
  Future<void> applyFilters({
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
    String? categoryId,
  }) async {
    _startDate = startDate;
    _endDate = endDate;
    _filterType = type;
    _filterCategoryId = categoryId;

    await Future.wait([loadTransactions(refresh: true), loadSummary()]);
  }

  // Limpar filtros
  Future<void> clearFilters() async {
    _startDate = null;
    _endDate = null;
    _filterType = null;
    _filterCategoryId = null;

    await Future.wait([loadTransactions(refresh: true), loadSummary()]);
  }

  // Obter categoria por ID
  TransactionCategory? getCategoryById(String id) {
    try {
      return _categories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  // Obter categorias por tipo
  List<TransactionCategory> getCategoriesByType(TransactionType type) {
    return _categories.where((cat) => cat.type == type).toList();
  }

  // Calcular totais
  double get totalIncome {
    return _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.displayAmount);
  }

  double get totalExpenses {
    return _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.displayAmount);
  }

  double get balance => totalIncome - totalExpenses;

  // Limpar erro
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Refresh pull-to-refresh
  Future<void> refresh() async {
    await Future.wait([loadTransactions(refresh: true), loadSummary()]);
  }
}
