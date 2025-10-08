import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../controllers/dashboard_controller.dart';
import '../../domain/entities/financial_summary.dart';

/// Widget que exibe o resumo financeiro do mês
class FinancialSummaryWidget extends StatelessWidget {
  const FinancialSummaryWidget({super.key});

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
                  Icons.account_balance_wallet,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Resumo Financeiro',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (controller.loadingState ==
                        DashboardLoadingState.loadingSummary ||
                    controller.isLoadingInitial)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            ListenableBuilder(
              listenable: controller,
              builder: (context, _) {
                final summary = controller.financialSummary;

                if (controller.lastError != null && summary == null) {
                  return _buildError(context, controller.lastError!.message);
                }

                if (summary == null) {
                  return _buildLoading();
                }

                return _buildSummaryContent(context, summary);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: CircularProgressIndicator(),
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
              'Erro ao carregar dados',
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

  Widget _buildSummaryContent(BuildContext context, FinancialSummary summary) {
    return Column(
      children: [
        // Saldo Atual
        _SummaryCard(
          title: 'Saldo Atual',
          amount: summary.totalBalance,
          icon: Icons.account_balance,
          color: summary.totalBalance >= 0 ? Colors.green : Colors.red,
        ),

        const SizedBox(height: 12),

        // Receitas e Despesas lado a lado
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                title: 'Receitas',
                amount: summary.monthlyIncome,
                icon: Icons.trending_up,
                color: Colors.green,
                isCompact: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                title: 'Despesas',
                amount: summary.monthlyExpenses,
                icon: Icons.trending_down,
                color: Colors.red,
                isCompact: true,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Variação do mês
        _buildBalanceVariation(context, summary),
      ],
    );
  }

  Widget _buildBalanceVariation(
    BuildContext context,
    FinancialSummary summary,
  ) {
    final variation = summary.balanceVariation;
    final isPositive = variation >= 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (isPositive ? Colors.green : Colors.red).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (isPositive ? Colors.green : Colors.red).withValues(
            alpha: 0.3,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            color: isPositive ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Variação do Mês',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                ),
                Text(
                  '${isPositive ? '+' : ''}R\$ ${variation.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isPositive ? '+' : ''}${summary.balanceVariationPercentage.toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isPositive ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;
  final bool isCompact;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isCompact ? 12 : 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: isCompact ? 20 : 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'R\$ ${amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: isCompact ? 18 : 24,
            ),
          ),
        ],
      ),
    );
  }
}
