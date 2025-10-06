import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/app/shared/models/transaction.dart';
import 'package:finance_app/app/shared/models/transaction_category.dart';
import 'package:finance_app/app/shared/models/auth_response.dart';

void main() {
  group('Transaction Model Tests', () {
    test('should create transaction with simple factory', () {
      // Arrange
      const description = 'Test Transaction';
      const amount = 100.0;
      const type = TransactionType.expense;
      const categoryId = 'category_1';

      // Act
      final transaction = Transaction.simple(
        description: description,
        amount: amount,
        type: type,
        categoryId: categoryId,
        transactionDate: DateTime.now(),
      );

      // Assert
      expect(transaction.description, description);
      expect(transaction.totalAmount, amount);
      expect(transaction.type, type);
      expect(transaction.categoryId, categoryId);
      expect(transaction.isInstallment, false);
    });

    test('should create installment transaction', () {
      // Arrange
      const description = 'Test Installment';
      const amount = 120.0;
      const type = TransactionType.expense;
      const categoryId = 'category_1';
      const totalInstallments = 3;

      // Act
      final transaction = Transaction.installments(
        description: description,
        amount: amount,
        type: type,
        categoryId: categoryId,
        totalInstallments: totalInstallments,
        valueInputType: ValueInputType.total,
        firstInstallmentDate: DateTime.now(),
      );

      // Assert
      expect(transaction.description, description);
      expect(transaction.totalAmount, amount);
      expect(transaction.type, type);
      expect(transaction.isInstallment, true);
      expect(transaction.totalInstallments, totalInstallments);
      expect(transaction.installmentAmount, amount / totalInstallments);
    });

    test('should format amount correctly', () {
      // Arrange
      final transaction = Transaction.simple(
        description: 'Test',
        amount: 1234.56,
        type: TransactionType.income,
        categoryId: 'cat_1',
        transactionDate: DateTime.now(),
      );

      // Act
      final formatted = transaction.formattedAmount;

      // Assert
      expect(formatted, contains('1234,56'));
    });
  });

  group('TransactionCategory Model Tests', () {
    test('should create transaction category', () {
      // Arrange
      const id = 'cat_1';
      const name = 'Test Category';
      const icon = '💰';
      const type = TransactionType.income;

      // Act
      final category = TransactionCategory(
        id: id,
        name: name,
        icon: icon,
        type: type,
      );

      // Assert
      expect(category.id, id);
      expect(category.name, name);
      expect(category.icon, icon);
      expect(category.type, type);
    });

    test('should return default categories', () {
      // Act
      final incomeCategories = TransactionCategory.defaultIncomeCategories;
      final expenseCategories = TransactionCategory.defaultExpenseCategories;

      // Assert
      expect(incomeCategories, isNotEmpty);
      expect(expenseCategories, isNotEmpty);
      expect(incomeCategories.first.type, TransactionType.income);
      expect(expenseCategories.first.type, TransactionType.expense);
    });
  });

  group('AuthResponse Model Tests', () {
    test('should create success auth response', () {
      // Arrange
      const token = 'test_token';
      const message = 'Login successful';

      // Act
      final authResponse = AuthResponse.success(token: token, message: message);

      // Assert
      expect(authResponse.success, true);
      expect(authResponse.token, token);
      expect(authResponse.message, message);
    });

    test('should create error auth response', () {
      // Arrange
      const message = 'Login failed';

      // Act
      final authResponse = AuthResponse.error(message: message);

      // Assert
      expect(authResponse.success, false);
      expect(authResponse.message, message);
      expect(authResponse.token, isNull);
    });

    test('should create auth response from map', () {
      // Arrange
      final map = {
        'success': true,
        'token': 'test_token',
        'message': 'Success',
      };

      // Act
      final authResponse = AuthResponse.fromMap(map);

      // Assert
      expect(authResponse.success, true);
      expect(authResponse.token, 'test_token');
      expect(authResponse.message, 'Success');
    });
  });
}
