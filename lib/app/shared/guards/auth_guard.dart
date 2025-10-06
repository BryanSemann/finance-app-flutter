import 'package:flutter_modular/flutter_modular.dart';
import '../services/auth_service.dart';
import '../constants/api_constants.dart';
import '../constants/dev_config.dart';

class AuthGuard extends RouteGuard {
  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    final authService = Modular.get<AuthService>();

    // Não fazer auto login - sempre verificar se já está logado
    final isLoggedIn = await authService.isLoggedIn();

    if (!isLoggedIn) {
      // Se não estiver logado, redirecionar para login
      Modular.to.pushReplacementNamed('/auth');
      return false;
    }

    // Log de desenvolvimento (opcional)
    if (ApiConstants.isDevelopmentMode && DevConfig.logApiCalls) {
      final isDev = await authService.isDevelopmentLogin();
      final userEmail = await authService.getDevelopmentUserEmail();

      if (isDev && userEmail != null) {
        // ignore: avoid_print
        print('🔓 AuthGuard: Permitindo acesso para usuário dev: $userEmail');
      } else {
        // ignore: avoid_print
        print('🔓 AuthGuard: Permitindo acesso para usuário de produção');
      }
    }

    return true;
  }
}
