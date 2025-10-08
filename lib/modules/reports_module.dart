import 'package:flutter_modular/flutter_modular.dart';
import '../features/reports/reports.dart' as reports;

/// Módulo de relatórios
class ReportsModule extends Module {
  @override
  void binds(Injector i) {
    // Dependencies are registered in AppModule
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const reports.ReportsPage());
  }
}
