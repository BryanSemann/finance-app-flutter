import 'package:flutter_modular/flutter_modular.dart';
import 'package:finance_app/app/modules/home/home_controller.dart';
import 'package:finance_app/app/modules/home/home_page.dart';
import 'package:finance_app/app/shared/repositories/transaction_repository.dart';
import 'package:finance_app/app/shared/services/api_service.dart';

class HomeModule extends Module {
  @override
  void binds(Injector i) {
    // Usar ApiService do AppModule (Singleton global)
    i.addLazySingleton<TransactionRepository>(
      () => TransactionRepository(i.get<ApiService>()),
    );
    i.addLazySingleton<HomeController>(
      () => HomeController(i.get<TransactionRepository>()),
    );
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const HomePage());
  }
}
