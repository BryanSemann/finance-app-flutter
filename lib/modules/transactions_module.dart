import 'package:flutter_modular/flutter_modular.dart';
import '../features/transactions/transactions.dart' as transactions;

/// Módulo de transações
class TransactionsModule extends Module {
  @override
  void binds(Injector i) {
    // Dependencies are registered in AppModule
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const transactions.TransactionsPage());
    r.child(
      '/create',
      child: (context) => const transactions.CreateTransactionPage(),
    );
  }
}
