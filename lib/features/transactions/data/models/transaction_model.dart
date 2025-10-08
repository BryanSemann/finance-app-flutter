import '../../domain/entities/transaction.dart';

/// Model de transação para serialização JSON
class TransactionModel {
  final String id;
  final String description;
  final double amount;
  final String type;
  final String category;
  final String date;
  final String? notes;
  final bool isRecurring;
  final int? installments;
  final int? currentInstallment;

  TransactionModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.notes,
    this.isRecurring = false,
    this.installments,
    this.currentInstallment,
  });

  /// Factory constructor do JSON
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      type: json['type'] ?? 'expense',
      category: json['category'] ?? '',
      date: json['date'] ?? DateTime.now().toIso8601String(),
      notes: json['notes'],
      isRecurring: json['is_recurring'] ?? false,
      installments: json['installments'],
      currentInstallment: json['current_installment'],
    );
  }

  /// Converte para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'type': type,
      'category': category,
      'date': date,
      'notes': notes,
      'is_recurring': isRecurring,
      'installments': installments,
      'current_installment': currentInstallment,
    };
  }

  /// Converte para entidade
  Transaction toEntity() {
    return Transaction(
      id: id,
      description: description,
      amount: amount,
      type: type == 'income' ? TransactionType.income : TransactionType.expense,
      category: category,
      date: DateTime.parse(date),
      notes: notes,
      isRecurring: isRecurring,
      installments: installments,
      currentInstallment: currentInstallment,
    );
  }

  /// Factory constructor da entidade
  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      description: transaction.description,
      amount: transaction.amount,
      type: transaction.type.name,
      category: transaction.category,
      date: transaction.date.toIso8601String(),
      notes: transaction.notes,
      isRecurring: transaction.isRecurring,
      installments: transaction.installments,
      currentInstallment: transaction.currentInstallment,
    );
  }
}
