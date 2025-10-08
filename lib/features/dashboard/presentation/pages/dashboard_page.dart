import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/financial_summary_widget.dart';
import '../widgets/dashboard_charts_widget.dart';
import '../widgets/recent_transactions_widget.dart';

/// Página principal do dashboard
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final DashboardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<DashboardController>();
    _controller.loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.refreshDashboard(),
            tooltip: 'Atualizar dados',
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (_controller.isLoadingInitial) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Carregando dados...'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => _controller.refreshDashboard(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resumo Financeiro
                  const FinancialSummaryWidget(),

                  const SizedBox(height: 24),

                  // Gráficos
                  const DashboardChartsWidget(),

                  const SizedBox(height: 24),

                  // Transações Recentes
                  const RecentTransactionsWidget(),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar para criar nova transação
          Modular.to.pushNamed('/transactions/create');
        },
        tooltip: 'Nova transação',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    // Não dispose do controller aqui pois ele é singleton
    super.dispose();
  }
}
