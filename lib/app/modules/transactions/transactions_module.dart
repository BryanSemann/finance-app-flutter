import 'package:flutter_modular/flutter_modular.dart';
import 'package:finance_app/app/modules/transactions/transactions_page.dart';
import 'package:finance_app/app/modules/transactions/create_transaction_page.dart';
import 'package:finance_app/app/modules/transactions/transactions_controller.dart';
import '../../shared/repositories/transaction_repository.dart';
import '../../shared/services/api_service.dart';

class TransactionsModule extends Module {
  @override
  void binds(Injector i) {
    // Registrar dependências localmente
    i.addLazySingleton<ApiService>(() => ApiService());
    i.addLazySingleton<TransactionRepository>(
      () => TransactionRepository(i.get<ApiService>()),
    );
    i.addLazySingleton<TransactionsController>(
      () => TransactionsController(i.get<TransactionRepository>()),
    );
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const TransactionsPage());
    r.child('/create', child: (context) => const CreateTransactionPage());
  }
}
