import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

/// Página para recuperação de senha
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  late final AuthController _authController;
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    _authController = Modular.get<AuthController>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Senha'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Ícone e título
                Icon(
                  _emailSent ? Icons.email : Icons.lock_reset,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  _emailSent ? 'Email Enviado!' : 'Esqueceu sua senha?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _emailSent
                      ? 'Enviamos um link de recuperação para seu email. Verifique sua caixa de entrada.'
                      : 'Digite seu email para receber um link de recuperação de senha.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                if (!_emailSent) ...[
                  // Campo de email
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite seu email';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Por favor, digite um email válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Botão de enviar
                  ListenableBuilder(
                    listenable: _authController,
                    builder: (context, _) {
                      return CustomButton(
                        text: 'Enviar Link de Recuperação',
                        onPressed: _authController.isLoading
                            ? null
                            : _handleForgotPassword,
                        isLoading: _authController.isLoading,
                      );
                    },
                  ),
                ] else ...[
                  // Botões após email enviado
                  CustomButton(
                    text: 'Reenviar Email',
                    onPressed: () {
                      setState(() {
                        _emailSent = false;
                      });
                    },
                    isSecondary: true,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Voltar ao Login',
                    onPressed: () {
                      Modular.to.navigate('/auth/');
                    },
                  ),
                ],

                const SizedBox(height: 24),

                // Voltar ao login
                if (!_emailSent)
                  TextButton(
                    onPressed: () {
                      Modular.to.pop();
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

  Future<void> _handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await _authController.forgotPassword(
      email: _emailController.text.trim(),
    );

    if (success && mounted) {
      setState(() {
        _emailSent = true;
      });
    }
  }
}
