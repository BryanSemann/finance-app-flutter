import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transactions_repository.dart';
import '../datasources/transactions_remote_datasource.dart';
import '../models/transaction_model.dart';

/// Implementação do repositório de transações
class TransactionsRepositoryImpl implements TransactionsRepository {
  final TransactionsRemoteDataSource _remoteDataSource;

  TransactionsRepositoryImpl({
    required TransactionsRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<({Failure? failure, List<Transaction> transactions})> getTransactions({
    int? limit,
    int? offset,
  }) async {
    try {
      final transactionModels = await _remoteDataSource.getTransactions(
        limit: limit,
        offset: offset,
      );

      return (
        failure: null,
        transactions: transactionModels
            .map((model) => model.toEntity())
            .toList(),
      );
    } on NetworkException catch (e) {
      return (
        failure: NetworkFailure(message: e.message, code: e.code),
        transactions: <Transaction>[],
      );
    } on ServerException catch (e) {
      return (
        failure: ServerFailure(message: e.message, code: e.code),
        transactions: <Transaction>[],
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(
          message: 'Erro inesperado ao buscar transações: $e',
        ),
        transactions: <Transaction>[],
      );
    }
  }

  @override
  Future<({Failure? failure, Transaction? transaction})> getTransactionById(
    String id,
  ) async {
    try {
      final transactionModel = await _remoteDataSource.getTransactionById(id);
      return (failure: null, transaction: transactionModel.toEntity());
    } on NetworkException catch (e) {
      return (
        failure: NetworkFailure(message: e.message, code: e.code),
        transaction: null,
      );
    } on ServerException catch (e) {
      return (
        failure: ServerFailure(message: e.message, code: e.code),
        transaction: null,
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(
          message: 'Erro inesperado ao buscar transação: $e',
        ),
        transaction: null,
      );
    }
  }

  @override
  Future<({Failure? failure, Transaction? transaction})> createTransaction(
    Transaction transaction,
  ) async {
    try {
      final transactionModel = TransactionModel.fromEntity(transaction);
      final createdModel = await _remoteDataSource.createTransaction(
        transactionModel,
      );

      return (failure: null, transaction: createdModel.toEntity());
    } on NetworkException catch (e) {
      return (
        failure: NetworkFailure(message: e.message, code: e.code),
        transaction: null,
      );
    } on ServerException catch (e) {
      return (
        failure: ServerFailure(message: e.message, code: e.code),
        transaction: null,
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(
          message: 'Erro inesperado ao criar transação: $e',
        ),
        transaction: null,
      );
    }
  }

  @override
  Future<({Failure? failure, Transaction? transaction})> updateTransaction(
    Transaction transaction,
  ) async {
    try {
      final transactionModel = TransactionModel.fromEntity(transaction);
      final updatedModel = await _remoteDataSource.updateTransaction(
        transactionModel,
      );

      return (failure: null, transaction: updatedModel.toEntity());
    } on NetworkException catch (e) {
      return (
        failure: NetworkFailure(message: e.message, code: e.code),
        transaction: null,
      );
    } on ServerException catch (e) {
      return (
        failure: ServerFailure(message: e.message, code: e.code),
        transaction: null,
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(
          message: 'Erro inesperado ao atualizar transação: $e',
        ),
        transaction: null,
      );
    }
  }

  @override
  Future<({Failure? failure, bool success})> deleteTransaction(
    String id,
  ) async {
    try {
      await _remoteDataSource.deleteTransaction(id);
      return (failure: null, success: true);
    } on NetworkException catch (e) {
      return (
        failure: NetworkFailure(message: e.message, code: e.code),
        success: false,
      );
    } on ServerException catch (e) {
      return (
        failure: ServerFailure(message: e.message, code: e.code),
        success: false,
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(
          message: 'Erro inesperado ao deletar transação: $e',
        ),
        success: false,
      );
    }
  }

  @override
  Future<({Failure? failure, List<Transaction> transactions})>
  getTransactionsByPeriod({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final transactionModels = await _remoteDataSource.getTransactionsByPeriod(
        startDate: startDate,
        endDate: endDate,
      );

      return (
        failure: null,
        transactions: transactionModels
            .map((model) => model.toEntity())
            .toList(),
      );
    } on NetworkException catch (e) {
      return (
        failure: NetworkFailure(message: e.message, code: e.code),
        transactions: <Transaction>[],
      );
    } on ServerException catch (e) {
      return (
        failure: ServerFailure(message: e.message, code: e.code),
        transactions: <Transaction>[],
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(
          message: 'Erro inesperado ao buscar transações por período: $e',
        ),
        transactions: <Transaction>[],
      );
    }
  }

  @override
  Future<({Failure? failure, List<Transaction> transactions})>
  getTransactionsByCategory(String category) async {
    try {
      final transactionModels = await _remoteDataSource
          .getTransactionsByCategory(category);

      return (
        failure: null,
        transactions: transactionModels
            .map((model) => model.toEntity())
            .toList(),
      );
    } on NetworkException catch (e) {
      return (
        failure: NetworkFailure(message: e.message, code: e.code),
        transactions: <Transaction>[],
      );
    } on ServerException catch (e) {
      return (
        failure: ServerFailure(message: e.message, code: e.code),
        transactions: <Transaction>[],
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(
          message: 'Erro inesperado ao buscar transações por categoria: $e',
        ),
        transactions: <Transaction>[],
      );
    }
  }
}
