import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:finance_app/app/modules/home/home_controller.dart';
import 'package:finance_app/app/modules/auth/auth_controller.dart';
import 'package:finance_app/app/shared/constants/api_constants.dart';
import 'package:finance_app/app/shared/constants/dev_config.dart';
import 'package:finance_app/app/shared/services/auth_service.dart';
import 'package:finance_app/app/shared/widgets/dev_login_panel.dart';
import 'package:finance_app/app/shared/theme/app_theme.dart';
import 'package:finance_app/app/shared/controllers/theme_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController controller;
  late final AuthController authController;
  String? _userEmail;
  bool _isDevLogin = false;

  @override
  void initState() {
    super.initState();
    controller = Modular.get<HomeController>();
    authController = Modular.get<AuthController>();
    controller.loadDashboardData();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (ApiConstants.isDevelopmentMode) {
      final authService = Modular.get<AuthService>();
      final isDevLogin = await authService.isDevelopmentLogin();

      if (isDevLogin) {
        final userEmail = await authService.getDevelopmentUserEmail();

        if (mounted) {
          setState(() {
            _isDevLogin = true;
            _userEmail = userEmail;
          });
        }
      }
    }
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Logout'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await authController.logout();
      if (mounted) {
        Modular.to.pushReplacementNamed('/auth');
      }
    }
  }

  void _showDevUserSwitcher() {
    if (!_isDevLogin) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Trocar Usuário de Desenvolvimento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ApiConstants.devCredentials.entries.map((entry) {
            final userInfo = DevConfig.getTestUserInfo(entry.key);
            final isCurrentUser = entry.key == _userEmail;

            return ListTile(
              leading: Icon(
                isCurrentUser ? Icons.check_circle : Icons.person,
                color: isCurrentUser
                    ? AppTheme.incomeColor
                    : Theme.of(context).disabledColor,
              ),
              title: Text(userInfo?['name'] ?? entry.key),
              subtitle: Text('${entry.key} (${userInfo?['role'] ?? 'user'})'),
              onTap: isCurrentUser
                  ? null
                  : () async {
                      final navigator = Navigator.of(context);
                      final messenger = ScaffoldMessenger.of(context);

                      navigator.pop();
                      final authService = Modular.get<AuthService>();
                      await authService.quickDevLogin(entry.key);
                      _loadUserData();

                      messenger.showSnackBar(
                        SnackBar(
                          content: Text('Usuário alterado para: ${entry.key}'),
                          backgroundColor: AppTheme.primaryPurple,
                        ),
                      );
                    },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Finance App'),
            if (_isDevLogin && _userEmail != null)
              Text(
                'Dev: $_userEmail',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        backgroundColor: _isDevLogin
            ? AppTheme.primaryPurple.withOpacity(0.1)
            : Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: _toggleTheme,
            tooltip: 'Alternar Tema',
          ),
          if (_isDevLogin)
            IconButton(
              icon: const Icon(Icons.swap_horiz),
              onPressed: _showDevUserSwitcher,
              tooltip: 'Trocar Usuário Dev',
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner de informações de desenvolvimento
          if (ApiConstants.isDevelopmentMode)
            DevInfoBanner(authService: Modular.get<AuthService>()),

          Expanded(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                if (controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card de Saldo Total
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Saldo Total',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'R\$ ${controller.totalBalance.toStringAsFixed(2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Cards de Receitas e Despesas
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Receitas do Mês',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'R\$ ${controller.monthlyIncome.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: AppTheme.incomeColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
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
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Despesas do Mês',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'R\$ ${controller.monthlyExpenses.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: AppTheme.expenseColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Botões de Navegação
                      Text(
                        'Ações Rápidas',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),

                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 2.5,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () =>
                                Modular.to.pushNamed('/transactions'),
                            icon: const Icon(Icons.list),
                            label: const Text('Transações'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => Modular.to.pushNamed('/reports'),
                            icon: const Icon(Icons.analytics),
                            label: const Text('Relatórios'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Navegar para adicionar transação
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Nova Transação'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Navegar para configurações
                            },
                            icon: const Icon(Icons.settings),
                            label: const Text('Configurações'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleTheme() async {
    final themeController = Modular.get<ThemeController>();
    await themeController.toggleTheme();
  }
}
