import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../controllers/dashboard_controller.dart';
import '../../domain/entities/recent_transaction.dart';

/// Widget que exibe as transações recentes
class RecentTransactionsWidget extends StatelessWidget {
  const RecentTransactionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Modular.get<DashboardController>();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.history,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Transações Recentes',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (controller.loadingState ==
                    DashboardLoadingState.loadingTransactions)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => Modular.to.pushNamed('/transactions'),
                  tooltip: 'Ver todas as transações',
                ),
              ],
            ),
            const SizedBox(height: 16),

            ListenableBuilder(
              listenable: controller,
              builder: (context, _) {
                final transactions = controller.recentTransactions;

                if (controller.lastError != null && transactions.isEmpty) {
                  return _buildError(context, controller.lastError!.message);
                }

                if (transactions.isEmpty) {
                  return _buildEmptyState(context);
                }

                return _buildTransactionsList(context, transactions);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              'Erro ao carregar transações',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            Icon(Icons.receipt_long, color: Colors.grey.shade400, size: 64),
            const SizedBox(height: 16),
            Text(
              'Nenhuma transação encontrada',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Suas transações aparecerão aqui',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Modular.to.pushNamed('/transactions/create'),
              icon: const Icon(Icons.add),
              label: const Text('Criar primeira transação'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList(
    BuildContext context,
    List<RecentTransaction> transactions,
  ) {
    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length > 10 ? 10 : transactions.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return _buildTransactionItem(context, transaction);
          },
        ),

        if (transactions.length > 10) ...[
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Modular.to.pushNamed('/transactions'),
            child: Text(
              'Ver todas as ${transactions.length} transações',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    RecentTransaction transaction,
  ) {
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? Colors.green : Colors.red;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.1),
        child: Icon(
          _getTransactionIcon(transaction.categoryName),
          color: color,
          size: 20,
        ),
      ),
      title: Text(
        transaction.description,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transaction.categoryName,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
          ),
          Text(
            _formatDate(transaction.date),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade500,
              fontSize: 12,
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${isIncome ? '+' : '-'}R\$ ${transaction.amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (transaction.isPending)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Colors.orange.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                'Pendente',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.orange.shade700,
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
      onTap: () {
        // Navegar para detalhes da transação
        Modular.to.pushNamed('/transactions/${transaction.id}');
      },
    );
  }

  IconData _getTransactionIcon(String category) {
    // Mapear categorias para ícones
    switch (category.toLowerCase()) {
      case 'alimentação':
        return Icons.restaurant;
      case 'transporte':
        return Icons.directions_car;
      case 'saúde':
        return Icons.local_hospital;
      case 'educação':
        return Icons.school;
      case 'entretenimento':
        return Icons.movie;
      case 'compras':
        return Icons.shopping_cart;
      case 'casa':
        return Icons.home;
      case 'trabalho':
      case 'salário':
        return Icons.work;
      case 'investimentos':
        return Icons.trending_up;
      case 'outros':
      default:
        return Icons.category;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Hoje';
    } else if (difference == 1) {
      return 'Ontem';
    } else if (difference < 7) {
      return '$difference dias atrás';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
