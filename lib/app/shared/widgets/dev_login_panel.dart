import 'package:flutter/material.dart';
import '../constants/api_constants.dart';
import '../constants/dev_config.dart';
import '../services/auth_service.dart';

class DevLoginPanel extends StatelessWidget {
  final AuthService authService;
  final VoidCallback? onLoginSuccess;

  const DevLoginPanel({
    super.key,
    required this.authService,
    this.onLoginSuccess,
  });

  @override
  Widget build(BuildContext context) {
    // Só exibe o painel se estiver em modo de desenvolvimento
    if (!ApiConstants.isDevelopmentMode || !DevConfig.isDevMode) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border: Border.all(color: Colors.orange, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.developer_mode, color: Colors.orange.shade700),
              const SizedBox(width: 8),
              Text(
                'MODO DESENVOLVIMENTO',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Logins rápidos disponíveis:',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          ...ApiConstants.devCredentials.entries.map(
            (entry) => _buildQuickLoginButton(context, entry.key, entry.value),
          ),
          const SizedBox(height: 8),
          Text(
            'Todas as contas usam senhas simples para desenvolvimento.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLoginButton(
    BuildContext context,
    String email,
    String password,
  ) {
    final userInfo = DevConfig.getTestUserInfo(email);
    final userName = userInfo?['name'] ?? 'Usuário';
    final userRole = userInfo?['role'] ?? 'user';

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _performQuickLogin(context, email),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange.shade100,
          foregroundColor: Colors.orange.shade800,
          elevation: 1,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('$email ($userRole)', style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _performQuickLogin(BuildContext context, String email) async {
    try {
      // Mostrar loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final success = await authService.quickDevLogin(email);

      // Fechar loading
      if (context.mounted) {
        Navigator.of(context).pop();

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login de desenvolvimento realizado como: $email'),
              backgroundColor: Colors.green,
            ),
          );
          onLoginSuccess?.call();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro no login de desenvolvimento'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Fechar loading se ainda estiver aberto
      if (context.mounted) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}

// Widget para mostrar informações de desenvolvimento
class DevInfoBanner extends StatelessWidget {
  final AuthService authService;

  const DevInfoBanner({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    if (!ApiConstants.isDevelopmentMode || !DevConfig.showDevInfo) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<bool>(
      future: authService.isDevelopmentLogin(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.orange.shade100,
          child: FutureBuilder<String?>(
            future: authService.getDevelopmentUserEmail(),
            builder: (context, emailSnapshot) {
              return Row(
                children: [
                  Icon(
                    Icons.developer_mode,
                    size: 16,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Modo Desenvolvimento - Logado como: ${emailSnapshot.data ?? "Unknown"}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
