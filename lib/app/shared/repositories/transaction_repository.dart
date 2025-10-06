import '../models/transaction.dart';
import '../models/transaction_category.dart';
import '../services/api_service.dart';
import '../constants/api_constants.dart';

class TransactionRepository {
  final ApiService _apiService;

  TransactionRepository(this._apiService);

  // Buscar todas as transações
  Future<List<Transaction>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    String? category,
    String? categoryId, // Adicionar suporte para categoryId
    TransactionType? type,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String();
      }
      if (category != null) {
        queryParams['category'] = category;
      }
      if (categoryId != null) {
        queryParams['categoryId'] = categoryId;
      }
      if (page != null) {
        queryParams['page'] = page.toString();
      }
      if (limit != null) {
        queryParams['limit'] = limit.toString();
      }
      if (type != null) {
        queryParams['type'] = type.name;
      }

      final response = await _apiService.get(
        ApiConstants.transactions,
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => Transaction.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar transações: $e');
    }
  }

  // Buscar transação por ID
  Future<Transaction> getTransactionById(String id) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.transactions}/$id',
      );
      return Transaction.fromMap(response.data['data']);
    } catch (e) {
      throw Exception('Erro ao buscar transação: $e');
    }
  }

  // Criar nova transação
  Future<Transaction> createTransaction(Transaction transaction) async {
    try {
      final response = await _apiService.post(
        ApiConstants.transactions,
        data: transaction.toMap(),
      );

      return Transaction.fromMap(response.data['data']);
    } catch (e) {
      throw Exception('Erro ao criar transação: $e');
    }
  }

  // Atualizar transação
  Future<Transaction> updateTransaction(Transaction transaction) async {
    try {
      final response = await _apiService.put(
        '${ApiConstants.transactions}/${transaction.id}',
        data: transaction.toMap(),
      );

      return Transaction.fromMap(response.data['data']);
    } catch (e) {
      throw Exception('Erro ao atualizar transação: $e');
    }
  }

  // Deletar transação
  Future<void> deleteTransaction(String id) async {
    try {
      await _apiService.delete('${ApiConstants.transactions}/$id');
    } catch (e) {
      throw Exception('Erro ao deletar transação: $e');
    }
  }

  // Buscar resumo financeiro (dashboard)
  Future<Map<String, dynamic>> getFinancialSummary({DateTime? month}) async {
    try {
      final queryParams = <String, dynamic>{};

      if (month != null) {
        queryParams['month'] = month.toIso8601String();
      }

      final response = await _apiService.get(
        '${ApiConstants.transactions}/summary',
        queryParameters: queryParams,
      );

      return response.data['data'];
    } catch (e) {
      throw Exception('Erro ao buscar resumo financeiro: $e');
    }
  }

  // Alias para compatibilidade com o controller
  Future<Map<String, dynamic>> getSummary({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return getFinancialSummary(month: startDate);
  }

  // Listar categorias
  Future<List<TransactionCategory>> getCategories() async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.baseUrl}/categories',
      );

      final List<dynamic> categoriesData =
          response.data['data'] ?? response.data;
      return categoriesData
          .map((json) => TransactionCategory.fromMap(json))
          .toList();
    } catch (e) {
      // Se der erro, retornar categorias padrão
      return TransactionCategory.allDefaultCategories;
    }
  }

  // Buscar transações
  Future<List<Transaction>> searchTransactions(String query) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.transactions}/search',
        queryParameters: {'q': query},
      );

      final List<dynamic> transactionsData =
          response.data['data'] ?? response.data;
      return transactionsData.map((json) => Transaction.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Erro na busca: $e');
    }
  }

  // Duplicar transação
  Future<Transaction> duplicateTransaction(String id) async {
    try {
      final response = await _apiService.post(
        '${ApiConstants.transactions}/$id/duplicate',
      );

      final transactionData = response.data['data'] ?? response.data;
      return Transaction.fromMap(transactionData);
    } catch (e) {
      throw Exception('Erro ao duplicar transação: $e');
    }
  }
}
