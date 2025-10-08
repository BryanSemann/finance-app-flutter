import '../models/transaction_model.dart';

/// Interface para data source remoto de transações
abstract class TransactionsRemoteDataSource {
  /// Busca todas as transações
  Future<List<TransactionModel>> getTransactions({int? limit, int? offset});

  /// Busca transação por ID
  Future<TransactionModel> getTransactionById(String id);

  /// Cria nova transação
  Future<TransactionModel> createTransaction(TransactionModel transaction);

  /// Atualiza transação
  Future<TransactionModel> updateTransaction(TransactionModel transaction);

  /// Deleta transação
  Future<void> deleteTransaction(String id);

  /// Busca transações por período
  Future<List<TransactionModel>> getTransactionsByPeriod({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Busca transações por categoria
  Future<List<TransactionModel>> getTransactionsByCategory(String category);
}
