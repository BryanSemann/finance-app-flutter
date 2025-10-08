import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/features/authentication/data/datasources/auth_remote_datasource_impl.dart';
import 'package:finance_app/core/network/dio_client.dart';
import 'package:finance_app/app/shared/constants/api_constants.dart';

void main() {
  group('Development Login Tests', () {
    late AuthRemoteDataSourceImpl dataSource;

    setUp(() {
      // Criar um DioClient mock ou real para o teste
      dataSource = AuthRemoteDataSourceImpl(DioClient());
    });

    test('should login successfully with dev credentials', () async {
      // Arrange
      const email = 'dev@finance.com';
      const password = 'dev123';

      // Act
      final result = await dataSource.login(email: email, password: password);

      // Assert
      expect(result.success, isTrue);
      expect(result.token, equals(ApiConstants.devToken));
      expect(result.user?.email, equals(email));
      expect(result.user?.name, equals('Desenvolvedor'));
    });

    test('should fail with invalid dev credentials', () async {
      // Arrange
      const email = 'invalid@finance.com';
      const password = 'wrong';

      // Act & Assert
      expect(
        () async => await dataSource.login(email: email, password: password),
        throwsA(isA<Exception>()),
      );
    });

    test('should login with admin dev credentials', () async {
      // Arrange
      const email = 'admin@finance.com';
      const password = 'admin123';

      // Act
      final result = await dataSource.login(email: email, password: password);

      // Assert
      expect(result.success, isTrue);
      expect(result.token, equals(ApiConstants.devToken));
      expect(result.user?.email, equals(email));
      expect(result.user?.name, equals('Administrador'));
    });
  });
}
