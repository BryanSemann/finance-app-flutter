import '../../domain/entities/report.dart';

/// Modelo de dados para Report - implementa a conversão entre API e entidade
class ReportModel extends Report {
  const ReportModel({
    required super.id,
    required super.title,
    required super.type,
    required super.startDate,
    required super.endDate,
    required super.totalAmount,
    required super.transactionCount,
    required super.categories,
    required super.createdAt,
  });

  /// Cria um ReportModel a partir de JSON
  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as String,
      title: json['title'] as String,
      type: ReportType.values.firstWhere(
        (type) => type.value == json['type'],
        orElse: () => ReportType.expense,
      ),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      totalAmount: (json['total_amount'] as num).toDouble(),
      transactionCount: json['transaction_count'] as int,
      categories: (json['categories'] as List<dynamic>)
          .map(
            (category) =>
                ReportCategoryModel.fromJson(category as Map<String, dynamic>),
          )
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Converte o modelo para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type.value,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'total_amount': totalAmount,
      'transaction_count': transactionCount,
      'categories': categories
          .map((category) => (category as ReportCategoryModel).toJson())
          .toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Cria uma cópia do modelo com novos valores
  ReportModel copyWith({
    String? id,
    String? title,
    ReportType? type,
    DateTime? startDate,
    DateTime? endDate,
    double? totalAmount,
    int? transactionCount,
    List<ReportCategory>? categories,
    DateTime? createdAt,
  }) {
    return ReportModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalAmount: totalAmount ?? this.totalAmount,
      transactionCount: transactionCount ?? this.transactionCount,
      categories: categories ?? this.categories,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Modelo de dados para ReportCategory
class ReportCategoryModel extends ReportCategory {
  const ReportCategoryModel({
    required super.name,
    required super.amount,
    required super.percentage,
    required super.transactionCount,
  });

  /// Cria um ReportCategoryModel a partir de JSON
  factory ReportCategoryModel.fromJson(Map<String, dynamic> json) {
    return ReportCategoryModel(
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
      transactionCount: json['transaction_count'] as int,
    );
  }

  /// Converte o modelo para JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'percentage': percentage,
      'transaction_count': transactionCount,
    };
  }
}
