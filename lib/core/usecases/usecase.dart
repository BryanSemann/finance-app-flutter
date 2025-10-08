/// Classe base para todos os use cases da aplicação
///
/// [T] - Tipo de retorno do use case
/// [Params] - Tipo dos parâmetros do use case
abstract class UseCase<T, Params> {
  /// Executa o use case com os parâmetros fornecidos
  Future<T> call(Params params);
}

/// Classe para use cases que não precisam de parâmetros
class NoParams {
  const NoParams();
}
