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
    String? categoryId,
    TransactionType? type,
    int? page,
    int? limit,
  }) async {
    // Se estiver em modo de desenvolvimento, usar dados mockados
    if (ApiConstants.isDevelopmentMode) {
      return _getMockTransactions(
        startDate: startDate,
        endDate: endDate,
        categoryId: categoryId,
        type: type,
        page: page ?? 1,
        limit: limit ?? 20,
      );
    }

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
    if (ApiConstants.isDevelopmentMode) {
      final transactions = _getAllMockTransactions();
      return transactions.firstWhere(
        (t) => t.id == id,
        orElse: () => throw Exception('Transação não encontrada'),
      );
    }

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
    if (ApiConstants.isDevelopmentMode) {
      // Simular delay da API
      await Future.delayed(const Duration(milliseconds: 500));

      // Retornar transação com ID gerado
      final newId = DateTime.now().millisecondsSinceEpoch.toString();
      return Transaction(
        id: newId,
        uuid: newId,
        description: transaction.description,
        totalAmount: transaction.totalAmount,
        installmentAmount: transaction.installmentAmount,
        type: transaction.type,
        categoryId: transaction.categoryId,
        transactionDate: transaction.transactionDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isInstallment: transaction.isInstallment,
        totalInstallments: transaction.totalInstallments,
        currentInstallment: transaction.currentInstallment,
        valueInputType: transaction.valueInputType,
        recurrenceType: transaction.recurrenceType,
        notes: transaction.notes,
      );
    }

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
    if (ApiConstants.isDevelopmentMode) {
      // Simular delay da API
      await Future.delayed(const Duration(milliseconds: 300));
      return _getMockSummary();
    }

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
    // Se estiver em modo de desenvolvimento, usar categorias padrão
    if (ApiConstants.isDevelopmentMode) {
      // Simular delay da API
      await Future.delayed(const Duration(milliseconds: 200));
      return TransactionCategory.allDefaultCategories;
    }

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
    // Se estiver em modo de desenvolvimento, usar busca nos dados mockados
    if (ApiConstants.isDevelopmentMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      final allTransactions = _getAllMockTransactions();
      return allTransactions
          .where(
            (transaction) => transaction.description.toLowerCase().contains(
              query.toLowerCase(),
            ),
          )
          .toList();
    }

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
    if (ApiConstants.isDevelopmentMode) {
      final mockTransactions = _getAllMockTransactions();
      final transaction = mockTransactions.firstWhere((t) => t.id == id);
      return Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        uuid: DateTime.now().millisecondsSinceEpoch.toString(),
        description: '${transaction.description} (Cópia)',
        totalAmount: transaction.totalAmount,
        installmentAmount: transaction.installmentAmount,
        type: transaction.type,
        categoryId: transaction.categoryId,
        transactionDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isInstallment: transaction.isInstallment,
        totalInstallments: transaction.totalInstallments,
        currentInstallment: transaction.currentInstallment,
        valueInputType: transaction.valueInputType,
        recurrenceType: transaction.recurrenceType,
        recurrenceEndDate: transaction.recurrenceEndDate,
        recurrenceCount: transaction.recurrenceCount,
        notes: transaction.notes,
        location: transaction.location,
        tags: transaction.tags,
        metadata: transaction.metadata,
        isActive: transaction.isActive,
        isPending: transaction.isPending,
        parentTransactionId: transaction.parentTransactionId,
        installments: transaction.installments,
      );
    }

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

  // ===== MÉTODOS MOCK PARA DESENVOLVIMENTO =====

  List<Transaction> _getMockTransactions({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
    TransactionType? type,
    int page = 1,
    int limit = 20,
  }) {
    var transactions = _getAllMockTransactions();

    // Aplicar filtros
    if (startDate != null) {
      transactions = transactions
          .where(
            (t) => t.transactionDate.isAfter(
              startDate.subtract(const Duration(days: 1)),
            ),
          )
          .toList();
    }

    if (endDate != null) {
      transactions = transactions
          .where(
            (t) => t.transactionDate.isBefore(
              endDate.add(const Duration(days: 1)),
            ),
          )
          .toList();
    }

    if (categoryId != null) {
      transactions = transactions
          .where((t) => t.categoryId == categoryId)
          .toList();
    }

    if (type != null) {
      transactions = transactions.where((t) => t.type == type).toList();
    }

    // Ordenar por data (mais recente primeiro)
    transactions.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));

    // Aplicar paginação
    final startIndex = (page - 1) * limit;
    final endIndex = (startIndex + limit).clamp(0, transactions.length);

    if (startIndex >= transactions.length) return [];

    return transactions.sublist(startIndex, endIndex);
  }

  List<Transaction> _getAllMockTransactions() {
    final now = DateTime.now();
    final categories = TransactionCategory.allDefaultCategories;

    return [
      // Receitas
      _createMockTransaction(
        '1',
        'Salário',
        5500.00,
        DateTime(now.year, now.month, 1),
        TransactionType.income,
        categories.firstWhere((c) => c.name == 'Salário').id,
      ),
      _createMockTransaction(
        '2',
        'Freelance desenvolvimento',
        1200.00,
        DateTime(now.year, now.month, 15),
        TransactionType.income,
        categories
            .firstWhere(
              (c) => c.name == 'Freelance',
              orElse: () => categories.first,
            )
            .id,
      ),
      _createMockTransaction(
        '3',
        'Venda online',
        350.00,
        DateTime(now.year, now.month, 20),
        TransactionType.income,
        categories
            .firstWhere(
              (c) => c.name == 'Outros',
              orElse: () => categories.first,
            )
            .id,
      ),

      // Despesas
      _createMockTransaction(
        '4',
        'Supermercado BigMart',
        280.50,
        DateTime(now.year, now.month, now.day - 1),
        TransactionType.expense,
        categories
            .firstWhere(
              (c) => c.name == 'Alimentação',
              orElse: () => categories.first,
            )
            .id,
      ),
      _createMockTransaction(
        '5',
        'Posto de gasolina',
        95.00,
        DateTime(now.year, now.month, now.day - 2),
        TransactionType.expense,
        categories
            .firstWhere(
              (c) => c.name == 'Transporte',
              orElse: () => categories.first,
            )
            .id,
      ),
      _createMockTransaction(
        '6',
        'Conta de luz',
        150.75,
        DateTime(now.year, now.month, 10),
        TransactionType.expense,
        categories
            .firstWhere((c) => c.name == 'Casa', orElse: () => categories.first)
            .id,
      ),
      _createMockTransaction(
        '7',
        'Netflix',
        25.90,
        DateTime(now.year, now.month, 5),
        TransactionType.expense,
        categories
            .firstWhere(
              (c) => c.name == 'Lazer',
              orElse: () => categories.first,
            )
            .id,
      ),
      _createMockTransaction(
        '8',
        'Farmácia Drogasil',
        45.80,
        DateTime(now.year, now.month, 8),
        TransactionType.expense,
        categories
            .firstWhere(
              (c) => c.name == 'Saúde',
              orElse: () => categories.first,
            )
            .id,
      ),
      _createMockTransaction(
        '9',
        'Restaurante Japonês',
        120.00,
        DateTime(now.year, now.month, 12),
        TransactionType.expense,
        categories
            .firstWhere(
              (c) => c.name == 'Alimentação',
              orElse: () => categories.first,
            )
            .id,
      ),
      _createMockTransaction(
        '10',
        'Curso online',
        89.90,
        DateTime(now.year, now.month, 18),
        TransactionType.expense,
        categories
            .firstWhere(
              (c) => c.name == 'Educação',
              orElse: () => categories.first,
            )
            .id,
      ),
      _createMockTransaction(
        '11',
        'Uber',
        18.50,
        DateTime(now.year, now.month, now.day),
        TransactionType.expense,
        categories
            .firstWhere(
              (c) => c.name == 'Transporte',
              orElse: () => categories.first,
            )
            .id,
      ),
      _createMockTransaction(
        '12',
        'Mercado da esquina',
        35.60,
        DateTime(now.year, now.month, now.day),
        TransactionType.expense,
        categories
            .firstWhere(
              (c) => c.name == 'Alimentação',
              orElse: () => categories.first,
            )
            .id,
      ),

      // Transações do mês passado
      _createMockTransaction(
        '13',
        'Salário Setembro',
        5500.00,
        DateTime(now.year, now.month - 1, 1),
        TransactionType.income,
        categories
            .firstWhere(
              (c) => c.name == 'Salário',
              orElse: () => categories.first,
            )
            .id,
      ),
      _createMockTransaction(
        '14',
        'Aluguel',
        1200.00,
        DateTime(now.year, now.month - 1, 5),
        TransactionType.expense,
        categories
            .firstWhere((c) => c.name == 'Casa', orElse: () => categories.first)
            .id,
      ),
      _createMockTransaction(
        '15',
        'Investimento CDB',
        1000.00,
        DateTime(now.year, now.month - 1, 10),
        TransactionType.expense,
        categories
            .firstWhere(
              (c) => c.name == 'Investimentos',
              orElse: () => categories.first,
            )
            .id,
      ),
    ];
  }

  Transaction _createMockTransaction(
    String id,
    String description,
    double amount,
    DateTime date,
    TransactionType type,
    String categoryId,
  ) {
    final adjustedAmount = type == TransactionType.expense
        ? -amount.abs()
        : amount.abs();
    final now = DateTime.now();

    return Transaction(
      id: id,
      uuid: id,
      description: description,
      totalAmount: adjustedAmount,
      installmentAmount: adjustedAmount,
      type: type,
      categoryId: categoryId,
      transactionDate: date,
      createdAt: now,
      updatedAt: now,
    );
  }

  Map<String, dynamic> _getMockSummary() {
    final transactions = _getAllMockTransactions();
    final now = DateTime.now();
    final currentMonthTransactions = transactions
        .where(
          (t) =>
              t.transactionDate.year == now.year &&
              t.transactionDate.month == now.month,
        )
        .toList();

    double totalIncome = 0;
    double totalExpenses = 0;

    for (final transaction in currentMonthTransactions) {
      if (transaction.type == TransactionType.income) {
        totalIncome += transaction.totalAmount;
      } else {
        totalExpenses += transaction.totalAmount.abs();
      }
    }

    return {
      'totalIncome': totalIncome,
      'totalExpenses': totalExpenses,
      'balance': totalIncome - totalExpenses,
      'transactionCount': currentMonthTransactions.length,
      'period': 'Outubro 2025',
    };
  }
}
