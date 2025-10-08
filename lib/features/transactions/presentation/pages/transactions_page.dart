import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../domain/entities/transaction.dart';
import '../controllers/transactions_controller.dart';

/// Página principal de transações
class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late final TransactionsController controller;

  @override
  void initState() {
    super.initState();
    controller = Modular.get<TransactionsController>();
    controller.loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transações'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.lastError != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Erro ao carregar transações',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.lastError!.message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.loadTransactions(),
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          final transactions = controller.transactions;

          if (transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma transação encontrada',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Adicione sua primeira transação para começar',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              final isExpense = transaction.type == TransactionType.expense;

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isExpense
                        ? Colors.red[100]
                        : Colors.green[100],
                    child: Icon(
                      isExpense ? Icons.remove : Icons.add,
                      color: isExpense ? Colors.red[700] : Colors.green[700],
                    ),
                  ),
                  title: Text(transaction.description),
                  subtitle: Text(
                    '${transaction.category} • ${_formatDate(transaction.date)}',
                  ),
                  trailing: Text(
                    'R\$ ${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: isExpense ? Colors.red[700] : Colors.green[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () => _showTransactionDetails(transaction),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Modular.to.pushNamed('/transactions/create'),
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _showTransactionDetails(Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(transaction.description),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Categoria: ${transaction.category}'),
            Text('Data: ${_formatDate(transaction.date)}'),
            Text('Valor: R\$ ${transaction.amount.toStringAsFixed(2)}'),
            Text('Tipo: ${transaction.type.displayName}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.deleteTransaction(transaction.id);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
