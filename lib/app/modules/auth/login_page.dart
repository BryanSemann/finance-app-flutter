import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:finance_app/app/modules/auth/auth_controller.dart';
import 'package:finance_app/app/shared/constants/api_constants.dart';
import 'package:finance_app/app/shared/constants/dev_config.dart';
import 'package:finance_app/app/shared/services/auth_service.dart';
import 'package:finance_app/app/shared/widgets/dev_login_panel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AuthController controller;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    controller = Modular.get<AuthController>();
    _checkAutoLogin();
  }

  // Não fazer auto-login - deixar usuário escolher quando fazer login
  Future<void> _checkAutoLogin() async {
    // Auto login desabilitado - usuário deve fazer login manualmente
    // ou usar o painel de desenvolvimento se necessário
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      controller.clearError();

      final success = await controller.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        Modular.to.pushReplacementNamed('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Banner de informações de desenvolvimento
            if (ApiConstants.isDevelopmentMode)
              DevInfoBanner(authService: Modular.get<AuthService>()),

            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo/Título
                        Icon(
                          Icons.account_balance_wallet,
                          size: 80,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Finance App',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Entre em sua conta',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 48),

                        // Campo Email
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            // Skip validation em modo de desenvolvimento
                            if (DevConfig.skipEmailValidation &&
                                ApiConstants.isDevelopmentMode) {
                              return null;
                            }

                            if (value == null || value.isEmpty) {
                              return 'Por favor, digite seu email';
                            }
                            if (!value.contains('@')) {
                              return 'Por favor, digite um email válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Campo Senha
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            prefixIcon: const Icon(Icons.lock_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            // Skip validation em modo de desenvolvimento
                            if (DevConfig.skipPasswordStrength &&
                                ApiConstants.isDevelopmentMode) {
                              return null;
                            }

                            if (value == null || value.isEmpty) {
                              return 'Por favor, digite sua senha';
                            }
                            if (value.length < 6) {
                              return 'A senha deve ter pelo menos 6 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Mensagem de erro
                        AnimatedBuilder(
                          animation: controller,
                          builder: (context, _) {
                            if (controller.hasError) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.red.shade200,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red.shade700,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        controller.errorMessage,
                                        style: TextStyle(
                                          color: Colors.red.shade700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),

                        // Botão Login
                        AnimatedBuilder(
                          animation: controller,
                          builder: (context, _) {
                            return ElevatedButton(
                              onPressed: controller.isLoading
                                  ? null
                                  : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: controller.isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : const Text(
                                      'Entrar',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // Link para registro
                        TextButton(
                          onPressed: () {
                            Modular.to.pushNamed('/auth/register');
                          },
                          child: const Text('Não tem conta? Criar conta'),
                        ),

                        // Link esqueci senha
                        TextButton(
                          onPressed: () {
                            // TODO: Implementar recuperação de senha
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Funcionalidade em desenvolvimento',
                                ),
                              ),
                            );
                          },
                          child: const Text('Esqueci minha senha'),
                        ),

                        const SizedBox(height: 24),

                        // Painel de desenvolvimento (só aparece em modo dev)
                        if (ApiConstants.isDevelopmentMode)
                          DevLoginPanel(
                            authService: Modular.get<AuthService>(),
                            onLoginSuccess: () {
                              if (mounted) {
                                Modular.to.pushReplacementNamed('/home');
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
