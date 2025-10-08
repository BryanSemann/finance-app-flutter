import 'package:flutter_modular/flutter_modular.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';

/// Módulo do dashboard
class DashboardModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const DashboardPage());
  }
}
