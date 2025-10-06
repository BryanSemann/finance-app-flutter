import 'package:flutter_modular/flutter_modular.dart';
import 'package:finance_app/app/modules/reports/reports_page.dart';

class ReportsModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const ReportsPage());
  }
}
