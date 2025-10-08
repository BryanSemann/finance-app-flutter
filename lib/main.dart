import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'app.dart';
import 'app/app_module.dart';

void main() {
  // Configurações iniciais
  WidgetsFlutterBinding.ensureInitialized();

  // Executar aplicação
  runApp(ModularApp(module: AppModule(), child: const FinanceApp()));
}
