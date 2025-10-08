import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/transactions_repository.dart';

/// Use case para deletar transação
class DeleteTransactionUseCase
    implements UseCase<({Failure? failure, bool success}), String> {
  final TransactionsRepository _repository;

  DeleteTransactionUseCase(this._repository);

  @override
  Future<({Failure? failure, bool success})> call(String id) async {
    return await _repository.deleteTransaction(id);
  }
}
