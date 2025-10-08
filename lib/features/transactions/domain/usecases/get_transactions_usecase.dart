import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/transaction.dart';
import '../repositories/transactions_repository.dart';

/// Parâmetros para buscar transações
class GetTransactionsParams {
  final int? limit;
  final int? offset;

  const GetTransactionsParams({this.limit, this.offset});
}

/// Use case para buscar transações
class GetTransactionsUseCase
    implements
        UseCase<
          ({Failure? failure, List<Transaction> transactions}),
          GetTransactionsParams
        > {
  final TransactionsRepository _repository;

  GetTransactionsUseCase(this._repository);

  @override
  Future<({Failure? failure, List<Transaction> transactions})> call(
    GetTransactionsParams params,
  ) async {
    return await _repository.getTransactions(
      limit: params.limit,
      offset: params.offset,
    );
  }
}
