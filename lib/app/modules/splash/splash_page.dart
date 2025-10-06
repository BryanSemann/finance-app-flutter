import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:finance_app/app/modules/auth/auth_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Aguardar um pouco para mostrar o splash
    await Future.delayed(const Duration(seconds: 2));

    try {
      final authController = Modular.get<AuthController>();
      final isLoggedIn = await authController.checkAuthStatus();

      if (mounted) {
        if (isLoggedIn) {
          Modular.to.pushReplacementNamed('/home');
        } else {
          Modular.to.pushReplacementNamed('/auth');
        }
      }
    } catch (e) {
      // Em caso de erro, redirecionar para login
      if (mounted) {
        Modular.to.pushReplacementNamed('/auth');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.account_balance_wallet,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
            ),

            const SizedBox(height: 24),

            // Nome do app
            Text(
              'Finance App',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Subtítulo
            Text(
              'Gerencie suas finanças com facilidade',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.white70),
            ),

            const SizedBox(height: 48),

            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
