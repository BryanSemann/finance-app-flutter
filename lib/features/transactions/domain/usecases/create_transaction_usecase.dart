import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/transaction.dart';
import '../repositories/transactions_repository.dart';

/// Use case para criar transação
class CreateTransactionUseCase
    implements
        UseCase<({Failure? failure, Transaction? transaction}), Transaction> {
  final TransactionsRepository _repository;

  CreateTransactionUseCase(this._repository);

  @override
  Future<({Failure? failure, Transaction? transaction})> call(
    Transaction transaction,
  ) async {
    return await _repository.createTransaction(transaction);
  }
}
