import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/transaction_model.dart';
import 'transactions_remote_datasource.dart';

/// Implementação do data source remoto de transações
class TransactionsRemoteDataSourceImpl implements TransactionsRemoteDataSource {
  final DioClient _client;

  TransactionsRemoteDataSourceImpl(this._client);

  @override
  Future<List<TransactionModel>> getTransactions({
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final response = await _client.get(
        ApiEndpoints.transactions,
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => TransactionModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(message: 'Erro ao buscar transações: $e');
    }
  }

  @override
  Future<TransactionModel> getTransactionById(String id) async {
    try {
      final response = await _client.get('${ApiEndpoints.transactions}/$id');
      return TransactionModel.fromJson(response.data['data']);
    } catch (e) {
      throw ServerException(message: 'Erro ao buscar transação: $e');
    }
  }

  @override
  Future<TransactionModel> createTransaction(
    TransactionModel transaction,
  ) async {
    try {
      final response = await _client.post(
        ApiEndpoints.transactions,
        data: transaction.toJson(),
      );
      return TransactionModel.fromJson(response.data['data']);
    } catch (e) {
      throw ServerException(message: 'Erro ao criar transação: $e');
    }
  }

  @override
  Future<TransactionModel> updateTransaction(
    TransactionModel transaction,
  ) async {
    try {
      final response = await _client.put(
        '${ApiEndpoints.transactions}/${transaction.id}',
        data: transaction.toJson(),
      );
      return TransactionModel.fromJson(response.data['data']);
    } catch (e) {
      throw ServerException(message: 'Erro ao atualizar transação: $e');
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      await _client.delete('${ApiEndpoints.transactions}/$id');
    } catch (e) {
      throw ServerException(message: 'Erro ao deletar transação: $e');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByPeriod({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _client.get(
        '${ApiEndpoints.transactions}/period',
        queryParameters: {
          'start_date': startDate.toIso8601String().split('T')[0],
          'end_date': endDate.toIso8601String().split('T')[0],
        },
      );

      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => TransactionModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(
        message: 'Erro ao buscar transações por período: $e',
      );
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByCategory(
    String category,
  ) async {
    try {
      final response = await _client.get(
        '${ApiEndpoints.transactions}/category/$category',
      );

      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => TransactionModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(
        message: 'Erro ao buscar transações por categoria: $e',
      );
    }
  }
}
