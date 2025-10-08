import 'package:flutter/foundation.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/domain.dart';

/// Estados de carregamento das transações
enum TransactionsLoadingState { idle, loading, creating, deleting, refreshing }

/// Controlador de estado para transações
class TransactionsController extends ChangeNotifier {
  final GetTransactionsUseCase _getTransactionsUseCase;
  final CreateTransactionUseCase _createTransactionUseCase;
  final DeleteTransactionUseCase _deleteTransactionUseCase;

  TransactionsController({
    required GetTransactionsUseCase getTransactionsUseCase,
    required CreateTransactionUseCase createTransactionUseCase,
    required DeleteTransactionUseCase deleteTransactionUseCase,
  }) : _getTransactionsUseCase = getTransactionsUseCase,
       _createTransactionUseCase = createTransactionUseCase,
       _deleteTransactionUseCase = deleteTransactionUseCase;

  // Estados privados
  TransactionsLoadingState _loadingState = TransactionsLoadingState.idle;
  List<Transaction> _transactions = [];
  Failure? _lastError;

  // Getters
  TransactionsLoadingState get loadingState => _loadingState;
  List<Transaction> get transactions => _transactions;
  Failure? get lastError => _lastError;

  bool get isLoading => _loadingState == TransactionsLoadingState.loading;
  bool get isCreating => _loadingState == TransactionsLoadingState.creating;
  bool get isDeleting => _loadingState == TransactionsLoadingState.deleting;
  bool get isRefreshing => _loadingState == TransactionsLoadingState.refreshing;
  bool get hasData => _transactions.isNotEmpty;

  /// Carrega as transações
  Future<void> loadTransactions({bool refresh = false}) async {
    if (!refresh && _loadingState != TransactionsLoadingState.idle) return;

    _loadingState = refresh
        ? TransactionsLoadingState.refreshing
        : TransactionsLoadingState.loading;
    _lastError = null;
    notifyListeners();

    try {
      final result = await _getTransactionsUseCase.call(
        const GetTransactionsParams(),
      );

      if (result.failure != null) {
        _lastError = result.failure;
      } else {
        _transactions = result.transactions;
        _lastError = null;
      }
    } catch (e) {
      _lastError = UnexpectedFailure(
        message: 'Erro inesperado ao carregar transações: $e',
      );
    } finally {
      _loadingState = TransactionsLoadingState.idle;
      notifyListeners();
    }
  }

  /// Cria nova transação
  Future<bool> createTransaction(Transaction transaction) async {
    if (_loadingState != TransactionsLoadingState.idle) return false;

    _loadingState = TransactionsLoadingState.creating;
    _lastError = null;
    notifyListeners();

    try {
      final result = await _createTransactionUseCase.call(transaction);

      if (result.failure != null) {
        _lastError = result.failure;
        return false;
      } else {
        // Adiciona a nova transação à lista local
        if (result.transaction != null) {
          _transactions.insert(0, result.transaction!);
        }
        _lastError = null;
        return true;
      }
    } catch (e) {
      _lastError = UnexpectedFailure(
        message: 'Erro inesperado ao criar transação: $e',
      );
      return false;
    } finally {
      _loadingState = TransactionsLoadingState.idle;
      notifyListeners();
    }
  }

  /// Deleta transação
  Future<bool> deleteTransaction(String id) async {
    if (_loadingState != TransactionsLoadingState.idle) return false;

    _loadingState = TransactionsLoadingState.deleting;
    _lastError = null;
    notifyListeners();

    try {
      final result = await _deleteTransactionUseCase.call(id);

      if (result.failure != null) {
        _lastError = result.failure;
        return false;
      } else {
        // Remove da lista local
        _transactions.removeWhere((transaction) => transaction.id == id);
        _lastError = null;
        return result.success;
      }
    } catch (e) {
      _lastError = UnexpectedFailure(
        message: 'Erro inesperado ao deletar transação: $e',
      );
      return false;
    } finally {
      _loadingState = TransactionsLoadingState.idle;
      notifyListeners();
    }
  }

  /// Limpa erro
  void clearError() {
    _lastError = null;
    notifyListeners();
  }

  /// Inicializa o controller
  Future<void> initialize() async {
    await loadTransactions();
  }
}
