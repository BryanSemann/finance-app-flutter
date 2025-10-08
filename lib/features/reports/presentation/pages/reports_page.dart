import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../domain/entities/report.dart';
import '../controllers/reports_controller.dart';

/// Página principal de relatórios
class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  late final ReportsController controller;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    controller = Modular.get<ReportsController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Seleção de período
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Período',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => _selectStartDate(),
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: 'Data Inicial',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.calendar_today),
                                  ),
                                  child: Text(_formatDate(_startDate)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InkWell(
                                onTap: () => _selectEndDate(),
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: 'Data Final',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.calendar_today),
                                  ),
                                  child: Text(_formatDate(_endDate)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Botões de relatórios
                _buildReportButton(
                  'Relatório de Despesas',
                  Icons.trending_down,
                  Colors.red,
                  () => _generateExpenseReport(),
                ),
                const SizedBox(height: 8),
                _buildReportButton(
                  'Relatório de Receitas',
                  Icons.trending_up,
                  Colors.green,
                  () => _generateIncomeReport(),
                ),
                const SizedBox(height: 8),
                _buildReportButton(
                  'Relatório por Categoria',
                  Icons.pie_chart,
                  Colors.blue,
                  () => _generateCategoryReport(),
                ),
                const SizedBox(height: 24),

                // Resultado do relatório
                if (controller.isLoading) ...[
                  const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Gerando relatório...'),
                      ],
                    ),
                  ),
                ] else if (controller.errorMessage != null) ...[
                  Card(
                    color: Colors.red[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(Icons.error, color: Colors.red[700], size: 48),
                          const SizedBox(height: 8),
                          Text(
                            'Erro ao gerar relatório',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.red[700]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red[600]),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: controller.clearError,
                            child: const Text('Fechar'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else if (controller.currentReport != null) ...[
                  Expanded(child: _buildReportView(controller.currentReport!)),
                ] else ...[
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.assessment,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Gere um relatório',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Selecione um tipo de relatório acima para começar',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildReportButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: controller.isLoading ? null : onPressed,
      icon: Icon(icon),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildReportView(Report report) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    report.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                IconButton(
                  onPressed: controller.clearCurrentReport,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSummaryCards(report),
            const SizedBox(height: 16),
            if (report.categories.isNotEmpty) ...[
              Text(
                'Detalhes por Categoria',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: report.categories.length,
                  itemBuilder: (context, index) {
                    final category = report.categories[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text(category.name),
                        subtitle: Text(
                          '${category.transactionCount} transações',
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'R\$ ${category.amount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('${category.percentage.toStringAsFixed(1)}%'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(Report report) {
    return Row(
      children: [
        Expanded(
          child: Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.monetization_on, color: Colors.blue[700]),
                  const SizedBox(height: 8),
                  Text('Total', style: TextStyle(color: Colors.blue[700])),
                  Text(
                    'R\$ ${report.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Card(
            color: Colors.green[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.receipt, color: Colors.green[700]),
                  const SizedBox(height: 8),
                  Text(
                    'Transações',
                    style: TextStyle(color: Colors.green[700]),
                  ),
                  Text(
                    '${report.transactionCount}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _startDate = date;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _endDate = date;
      });
    }
  }

  Future<void> _generateExpenseReport() async {
    await controller.generateExpenseReport(
      startDate: _startDate,
      endDate: _endDate,
    );
  }

  Future<void> _generateIncomeReport() async {
    await controller.generateIncomeReport(
      startDate: _startDate,
      endDate: _endDate,
    );
  }

  Future<void> _generateCategoryReport() async {
    await controller.generateCategoryReport(
      startDate: _startDate,
      endDate: _endDate,
      type: ReportType.expense, // Default para despesas
    );
  }
}
