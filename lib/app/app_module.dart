import 'package:flutter_modular/flutter_modular.dart';
import 'package:finance_app/app/modules/splash/splash_module.dart';
import 'package:finance_app/app/modules/auth/auth_module.dart';
import 'package:finance_app/app/modules/home/home_module.dart';
import 'package:finance_app/app/modules/transactions/transactions_module.dart';
import 'package:finance_app/app/modules/reports/reports_module.dart';
import 'package:finance_app/app/shared/services/api_service.dart';
import 'package:finance_app/app/shared/services/auth_service.dart';
import 'package:finance_app/app/modules/auth/auth_controller.dart';
import 'package:finance_app/app/shared/guards/auth_guard.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    // Serviços compartilhados
    i.addSingleton<ApiService>(ApiService.new);
    i.addSingleton<AuthService>(() => AuthService(i.get<ApiService>()));
    i.addSingleton<AuthController>(() => AuthController(i.get<AuthService>()));
  }

  @override
  void routes(RouteManager r) {
    // Rota inicial - Splash Screen
    r.module('/', module: SplashModule());

    // Módulo de Autenticação
    r.module('/auth', module: AuthModule());

    // Módulo Home (Dashboard) - Protegido
    r.module('/home', module: HomeModule(), guards: [AuthGuard()]);

    // Módulo de Transações - Protegido
    r.module(
      '/transactions',
      module: TransactionsModule(),
      guards: [AuthGuard()],
    );

    // Módulo de Relatórios - Protegido
    r.module('/reports', module: ReportsModule(), guards: [AuthGuard()]);
  }
}
