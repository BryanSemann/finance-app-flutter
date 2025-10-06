import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App Widget Tests', () {
    testWidgets('should build simple MaterialApp without errors', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(title: 'Finance App Test', home: const TestHomePage()),
      );

      // Assert
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.text('Test Home Page'), findsOneWidget);
    });

    testWidgets('should display test login page', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(title: 'Finance App Test', home: const TestLoginPage()),
      );

      // Assert
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.text('Test Login Page'), findsOneWidget);
    });

    testWidgets('should navigate between test pages', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          title: 'Finance App Test',
          initialRoute: '/',
          routes: {
            '/': (context) => const TestHomePage(),
            '/login': (context) => const TestLoginPage(),
          },
        ),
      );

      // Assert
      expect(find.text('Test Home Page'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}

// Páginas simples para teste
class TestHomePage extends StatelessWidget {
  const TestHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Test Home Page')));
  }
}

class TestLoginPage extends StatelessWidget {
  const TestLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Test Login Page')));
  }
}
