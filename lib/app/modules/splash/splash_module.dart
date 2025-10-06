import 'package:flutter_modular/flutter_modular.dart';
import 'package:finance_app/app/modules/splash/splash_page.dart';

class SplashModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const SplashPage());
  }
}
