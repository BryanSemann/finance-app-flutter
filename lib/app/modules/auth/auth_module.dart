import 'package:flutter_modular/flutter_modular.dart';
import 'package:finance_app/app/modules/auth/auth_controller.dart';
import 'package:finance_app/app/modules/auth/login_page.dart';
import 'package:finance_app/app/modules/auth/register_page.dart';
import 'package:finance_app/app/shared/services/auth_service.dart';

class AuthModule extends Module {
  @override
  void binds(Injector i) {
    i.addLazySingleton<AuthService>(() => AuthService(i.get()));
    i.addLazySingleton<AuthController>(
      () => AuthController(i.get<AuthService>()),
    );
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const LoginPage());
    r.child('/register', child: (context) => const RegisterPage());
  }
}
