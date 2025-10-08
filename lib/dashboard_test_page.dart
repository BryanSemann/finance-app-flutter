import 'package:flutter/material.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';

/// Página para testar o dashboard - versão simples
class DashboardTestPage extends StatelessWidget {
  const DashboardTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Dashboard - Teste'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Dashboard em Desenvolvimento'),
                  content: const Text(
                    'Este é o novo dashboard implementado com Clean Architecture. '
                    'Os dados reais virão da API quando estiver conectada.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'Sobre',
          ),
        ],
      ),
      body: const DashboardPage(),
    );
  }
}
