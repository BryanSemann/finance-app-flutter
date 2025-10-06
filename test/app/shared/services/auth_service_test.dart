import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/app/shared/services/auth_service.dart';
import 'package:finance_app/app/shared/services/api_service.dart';
import 'package:finance_app/app/shared/constants/api_constants.dart';
import 'package:finance_app/app/shared/constants/dev_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('AuthService Tests', () {
    late AuthService authService;
    late ApiService apiService;

    setUp(() {
      apiService = ApiService();
      authService = AuthService(apiService);
    });

    group('Development Login Tests', () {
      test('should handle development mode correctly', () {
        // Act & Assert - Verifica se as constantes estão definidas
        expect(ApiConstants.isDevelopmentMode, isA<bool>());
        expect(DevConfig.isDevMode, isA<bool>());
      });
    });

    group('Token Management Tests', () {
      test('should have logout method defined', () {
        // Act & Assert - Verifica se o AuthService tem o método logout
        expect(authService.logout, isA<Function>());
      });
    });

    group('Development Helper Tests', () {
      test('should return available dev credentials in development mode', () {
        // Act
        final credentials = authService.getAvailableDevCredentials();

        // Assert
        if (ApiConstants.isDevelopmentMode && DevConfig.isDevMode) {
          expect(credentials, isNotEmpty);
          expect(credentials, contains('dev@finance.com'));
        } else {
          expect(credentials, isEmpty);
        }
      });
    });
  });
}
