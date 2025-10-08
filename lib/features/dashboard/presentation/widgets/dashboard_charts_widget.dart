import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../controllers/dashboard_controller.dart';
import '../../domain/entities/dashboard_chart.dart';

/// Widget que exibe os gráficos do dashboard
class DashboardChartsWidget extends StatelessWidget {
  const DashboardChartsWidget({super.key});

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
                  Icons.analytics,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Análise Visual',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (controller.loadingState ==
                    DashboardLoadingState.loadingCharts)
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
                if (controller.lastError != null &&
                    controller.charts.isEmpty &&
                    controller.expensesChart == null) {
                  return _buildError(context, controller.lastError!.message);
                }

                return _buildChartsContent(context, controller);
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
              'Erro ao carregar gráficos',
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

  Widget _buildChartsContent(
    BuildContext context,
    DashboardController controller,
  ) {
    final hasExpensesChart = controller.expensesChart != null;
    final hasBalanceChart = controller.balanceChart != null;

    if (!hasExpensesChart && !hasBalanceChart) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        // Gráfico de despesas por categoria
        if (hasExpensesChart) ...[
          _buildChartSection(
            context,
            title: 'Despesas por Categoria',
            chart: controller.expensesChart!,
            icon: Icons.pie_chart,
          ),
          if (hasBalanceChart) const SizedBox(height: 24),
        ],

        // Gráfico de evolução do saldo
        if (hasBalanceChart)
          _buildChartSection(
            context,
            title: 'Evolução do Saldo',
            chart: controller.balanceChart!,
            icon: Icons.trending_up,
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            Icon(Icons.bar_chart, color: Colors.grey.shade400, size: 48),
            const SizedBox(height: 8),
            Text(
              'Nenhum dado disponível',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Text(
              'Os gráficos aparecerão quando houver transações',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection(
    BuildContext context, {
    required String title,
    required DashboardChart chart,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Substituir por implementação real de gráfico depois
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: _buildSimpleChart(context, chart),
        ),
      ],
    );
  }

  // Implementação simples de gráfico - substituir por biblioteca de gráficos depois
  Widget _buildSimpleChart(BuildContext context, DashboardChart chart) {
    if (chart.data.isEmpty) {
      return const Center(child: Text('Sem dados para exibir'));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chart.title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: chart.data.length,
              itemBuilder: (context, index) {
                final entry = chart.data.entries.elementAt(index);
                final percentage = _calculatePercentage(
                  entry.value,
                  chart.data,
                );

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildChartItem(
                    context,
                    label: entry.key,
                    value: entry.value,
                    percentage: percentage,
                    color: _getColorForIndex(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartItem(
    BuildContext context, {
    required String label,
    required double value,
    required double percentage,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          flex: 3,
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Text(
            'R\$ ${value.toStringAsFixed(0)}',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 40,
          child: Text(
            '${percentage.toStringAsFixed(0)}%',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  double _calculatePercentage(double value, Map<String, double> data) {
    final total = data.values.fold(0.0, (sum, v) => sum + v);
    if (total == 0) return 0;
    return (value / total) * 100;
  }

  Color _getColorForIndex(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    return colors[index % colors.length];
  }
}
