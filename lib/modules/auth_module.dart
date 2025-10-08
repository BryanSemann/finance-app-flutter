import 'package:flutter_modular/flutter_modular.dart';
import '../features/authentication/authentication.dart' as auth;

/// Módulo de autenticação
class AuthModule extends Module {
  @override
  void binds(Injector i) {
    // Dependencies are registered in AppModule
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const auth.LoginPage());
    r.child('/register', child: (context) => const auth.RegisterPage());
    r.child(
      '/forgot-password',
      child: (context) => const auth.ForgotPasswordPage(),
    );
    r.child(
      '/reset-password',
      child: (context) => const auth.ResetPasswordPage(),
    );
  }
}
