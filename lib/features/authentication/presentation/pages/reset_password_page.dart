import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

/// Página para redefinir senha
class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late final AuthController _authController;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _authController = Modular.get<AuthController>();
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redefinir Senha'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Ícone e título
                Icon(
                  Icons.lock_reset,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Redefinir Senha',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Digite o código que você recebeu por email e sua nova senha.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Campo de token/código
                CustomTextField(
                  controller: _tokenController,
                  label: 'Código de Verificação',
                  prefixIcon: Icons.verified_user_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite o código de verificação';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo de nova senha
                CustomTextField(
                  controller: _passwordController,
                  label: 'Nova Senha',
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_outlined,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite sua nova senha';
                    }
                    if (value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo de confirmação de senha
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirmar Nova Senha',
                  obscureText: _obscureConfirmPassword,
                  prefixIcon: Icons.lock_outlined,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, confirme sua nova senha';
                    }
                    if (value != _passwordController.text) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Botão de redefinir
                ListenableBuilder(
                  listenable: _authController,
                  builder: (context, _) {
                    return CustomButton(
                      text: 'Redefinir Senha',
                      onPressed: _authController.isLoading
                          ? null
                          : _handleResetPassword,
                      isLoading: _authController.isLoading,
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Voltar ao login
                TextButton(
                  onPressed: () {
                    Modular.to.navigate('/auth/');
                  },
                  child: Text(
                    'Voltar ao login',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),

                // Exibir erro se houver
                ListenableBuilder(
                  listenable: _authController,
                  builder: (context, _) {
                    if (_authController.lastError != null) {
                      return Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade300),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red.shade700,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _authController.lastError!.message,
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await _authController.resetPassword(
      token: _tokenController.text.trim(),
      newPassword: _passwordController.text,
    );

    if (success && mounted) {
      // Mostrar sucesso e navegar para login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha redefinida com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      // Aguardar um momento e navegar para login
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Modular.to.navigate('/auth/');
      }
    }
  }
}
