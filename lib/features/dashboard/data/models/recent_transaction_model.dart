import '../../domain/entities/recent_transaction.dart';

/// Model para transações recentes
class RecentTransactionModel extends RecentTransaction {
  const RecentTransactionModel({
    required super.id,
    required super.description,
    required super.amount,
    required super.type,
    required super.categoryName,
    required super.categoryIcon,
    required super.categoryColor,
    required super.date,
    required super.isPending,
  });

  /// Cria a partir de JSON da API
  factory RecentTransactionModel.fromJson(Map<String, dynamic> json) {
    return RecentTransactionModel(
      id: json['id'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: TransactionType.values.firstWhere(
        (type) => type.value == json['type'],
        orElse: () => TransactionType.expense,
      ),
      categoryName: json['category_name'] as String,
      categoryIcon: json['category_icon'] as String? ?? '💰',
      categoryColor: json['category_color'] as String? ?? '#757575',
      date: DateTime.parse(json['date'] as String),
      isPending: json['is_pending'] as bool? ?? false,
    );
  }

  /// Converte para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'type': type.value,
      'category_name': categoryName,
      'category_icon': categoryIcon,
      'category_color': categoryColor,
      'date': date.toIso8601String(),
      'is_pending': isPending,
    };
  }

  /// Cria a partir da entidade do domínio
  factory RecentTransactionModel.fromEntity(RecentTransaction entity) {
    return RecentTransactionModel(
      id: entity.id,
      description: entity.description,
      amount: entity.amount,
      type: entity.type,
      categoryName: entity.categoryName,
      categoryIcon: entity.categoryIcon,
      categoryColor: entity.categoryColor,
      date: entity.date,
      isPending: entity.isPending,
    );
  }

  /// Converte para entidade do domínio
  RecentTransaction toEntity() {
    return RecentTransaction(
      id: id,
      description: description,
      amount: amount,
      type: type,
      categoryName: categoryName,
      categoryIcon: categoryIcon,
      categoryColor: categoryColor,
      date: date,
      isPending: isPending,
    );
  }
}
