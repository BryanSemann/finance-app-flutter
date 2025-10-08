import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'core/network/dio_client.dart';
import 'core/storage/local_storage.dart';

/// Módulo principal da aplicação usando Clean Architecture
/// Versão temporária simplificada para resolver erros de compilação
class AppModule extends Module {
  @override
  void binds(Injector i) {
    // Core dependencies
    i.addSingleton<DioClient>(DioClient.new);
    i.addSingleton<LocalStorage>(LocalStorage.new);
  }

  @override
  void routes(RouteManager r) {
    // Tela temporária para testar a arquitetura
    r.child('/', child: (context) => const _TempHomePage());

    // Rotas são gerenciadas pelos módulos de feature individuais
  }
}

/// Widget temporário para testar a nova arquitetura
class _TempHomePage extends StatelessWidget {
  const _TempHomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finance App - New Architecture')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '🏗️ Nova Arquitetura Clean Architecture',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('✅ Core implementado'),
            Text('✅ Estrutura de features criada'),
            Text('🔄 Implementando autenticação...'),
            SizedBox(height: 24),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
