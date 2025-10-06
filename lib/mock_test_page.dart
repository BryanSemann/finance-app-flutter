import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'app/shared/repositories/transaction_repository.dart';
import 'app/shared/models/transaction.dart';
import 'app/shared/models/transaction_category.dart';

class MockTestPage extends StatefulWidget {
  const MockTestPage({super.key});

  @override
  State<MockTestPage> createState() => _MockTestPageState();
}

class _MockTestPageState extends State<MockTestPage> {
  late final TransactionRepository repository;
  List<Transaction> transactions = [];
  Map<String, dynamic>? summary;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    repository = TransactionRepository(Modular.get());
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final [txList, summaryData] = await Future.wait([
        repository.getTransactions(),
        repository.getSummary(),
      ]);

      setState(() {
        transactions = txList as List<Transaction>;
        summary = summaryData as Map<String, dynamic>;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Erro ao carregar dados mock: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mock Test - Transações'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resumo Financeiro
                  _buildSummaryCard(),
                  const SizedBox(height: 24),

                  // Lista de Transações
                  Text(
                    'Transações Mockadas (${transactions.length})',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return _buildTransactionCard(transaction);
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCard() {
    if (summary == null) return const SizedBox();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumo Financeiro - ${summary!['period']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem(
                  'Receitas',
                  summary!['totalIncome'] ?? 0,
                  Colors.green,
                  Icons.trending_up,
                ),
                _buildSummaryItem(
                  'Despesas',
                  summary!['totalExpenses'] ?? 0,
                  Colors.red,
                  Icons.trending_down,
                ),
                _buildSummaryItem(
                  'Saldo',
                  summary!['balance'] ?? 0,
                  (summary!['balance'] ?? 0) >= 0 ? Colors.green : Colors.red,
                  Icons.account_balance_wallet,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    String title,
    double value,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          'R\$ ${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    final category = TransactionCategory.allDefaultCategories
        .where((c) => c.id == transaction.categoryId)
        .firstOrNull;

    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? Colors.green : Colors.red;
    final sign = isIncome ? '+' : '';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Text(
            category?.icon ?? (isIncome ? '💰' : '💸'),
            style: const TextStyle(fontSize: 20),
          ),
        ),
        title: Text(
          transaction.description,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '${category?.name ?? 'Sem categoria'} • ${_formatDate(transaction.transactionDate)}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Text(
          '$sign R\$ ${transaction.totalAmount.abs().toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
