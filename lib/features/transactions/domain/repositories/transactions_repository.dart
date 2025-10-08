import '../../../../core/errors/failures.dart';
import '../entities/transaction.dart';

/// Repositório para transações
abstract class TransactionsRepository {
  /// Busca todas as transações
  Future<({Failure? failure, List<Transaction> transactions})> getTransactions({
    int? limit,
    int? offset,
  });

  /// Busca transação por ID
  Future<({Failure? failure, Transaction? transaction})> getTransactionById(
    String id,
  );

  /// Cria nova transação
  Future<({Failure? failure, Transaction? transaction})> createTransaction(
    Transaction transaction,
  );

  /// Atualiza transação
  Future<({Failure? failure, Transaction? transaction})> updateTransaction(
    Transaction transaction,
  );

  /// Deleta transação
  Future<({Failure? failure, bool success})> deleteTransaction(String id);

  /// Busca transações por período
  Future<({Failure? failure, List<Transaction> transactions})>
  getTransactionsByPeriod({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Busca transações por categoria
  Future<({Failure? failure, List<Transaction> transactions})>
  getTransactionsByCategory(String category);
}
