import 'transaction_category.dart';
import 'installment.dart';

class Transaction {
  final String id;
  final String uuid; // UUID do backend
  final String description; // Descrição principal
  final double totalAmount; // Valor total da transação
  final double installmentAmount; // Valor de cada parcela
  final TransactionType type; // Receita ou Despesa
  final String categoryId; // ID da categoria
  final DateTime transactionDate; // Data da transação
  final DateTime createdAt; // Quando foi criada
  final DateTime updatedAt; // Última atualização

  // Sistema de parcelamento
  final bool isInstallment; // Se é parcelada
  final int totalInstallments; // Número total de parcelas
  final int currentInstallment; // Parcela atual
  final ValueInputType valueInputType; // Como o valor foi informado

  // Recorrência
  final RecurrenceType recurrenceType;
  final DateTime? recurrenceEndDate;
  final int? recurrenceCount;

  // Campos opcionais
  final String? notes; // Observações adicionais
  final String? location; // Localização
  final List<String> tags; // Tags personalizadas
  final Map<String, dynamic>? metadata; // Dados extras

  // Status
  final bool isActive;
  final bool isPending; // Transação pendente

  // Relacionamentos
  final String? parentTransactionId; // Para parcelas/recorrências
  final List<Installment> installments; // Parcelas relacionadas

  const Transaction({
    required this.id,
    required this.uuid,
    required this.description,
    required this.totalAmount,
    required this.installmentAmount,
    required this.type,
    required this.categoryId,
    required this.transactionDate,
    required this.createdAt,
    required this.updatedAt,
    this.isInstallment = false,
    this.totalInstallments = 1,
    this.currentInstallment = 1,
    this.valueInputType = ValueInputType.total,
    this.recurrenceType = RecurrenceType.none,
    this.recurrenceEndDate,
    this.recurrenceCount,
    this.notes,
    this.location,
    this.tags = const [],
    this.metadata,
    this.isActive = true,
    this.isPending = false,
    this.parentTransactionId,
    this.installments = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uuid': uuid,
      'description': description,
      'totalAmount': totalAmount,
      'installmentAmount': installmentAmount,
      'type': type.value,
      'categoryId': categoryId,
      'transactionDate': transactionDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isInstallment': isInstallment,
      'totalInstallments': totalInstallments,
      'currentInstallment': currentInstallment,
      'valueInputType': valueInputType.value,
      'recurrenceType': recurrenceType.value,
      'recurrenceEndDate': recurrenceEndDate?.toIso8601String(),
      'recurrenceCount': recurrenceCount,
      'notes': notes,
      'location': location,
      'tags': tags,
      'metadata': metadata,
      'isActive': isActive,
      'isPending': isPending,
      'parentTransactionId': parentTransactionId,
      'installments': installments.map((e) => e.toMap()).toList(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] ?? '',
      uuid: map['uuid'] ?? '',
      description: map['description'] ?? '',
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      installmentAmount: (map['installmentAmount'] ?? 0.0).toDouble(),
      type: TransactionType.values.firstWhere(
        (e) => e.value == map['type'],
        orElse: () => TransactionType.expense,
      ),
      categoryId: map['categoryId'] ?? '',
      transactionDate: DateTime.parse(
        map['transactionDate'] ?? DateTime.now().toIso8601String(),
      ),
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        map['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      isInstallment: map['isInstallment'] ?? false,
      totalInstallments: map['totalInstallments'] ?? 1,
      currentInstallment: map['currentInstallment'] ?? 1,
      valueInputType: ValueInputType.values.firstWhere(
        (e) => e.value == map['valueInputType'],
        orElse: () => ValueInputType.total,
      ),
      recurrenceType: RecurrenceType.values.firstWhere(
        (e) => e.value == map['recurrenceType'],
        orElse: () => RecurrenceType.none,
      ),
      recurrenceEndDate: map['recurrenceEndDate'] != null
          ? DateTime.parse(map['recurrenceEndDate'])
          : null,
      recurrenceCount: map['recurrenceCount'],
      notes: map['notes'],
      location: map['location'],
      tags: List<String>.from(map['tags'] ?? []),
      metadata: map['metadata'],
      isActive: map['isActive'] ?? true,
      isPending: map['isPending'] ?? false,
      parentTransactionId: map['parentTransactionId'],
      installments:
          (map['installments'] as List?)
              ?.map((e) => Installment.fromMap(e))
              .toList() ??
          [],
    );
  }

  Transaction copyWith({
    String? id,
    String? uuid,
    String? description,
    double? totalAmount,
    double? installmentAmount,
    TransactionType? type,
    String? categoryId,
    DateTime? transactionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isInstallment,
    int? totalInstallments,
    int? currentInstallment,
    ValueInputType? valueInputType,
    RecurrenceType? recurrenceType,
    DateTime? recurrenceEndDate,
    int? recurrenceCount,
    String? notes,
    String? location,
    List<String>? tags,
    Map<String, dynamic>? metadata,
    bool? isActive,
    bool? isPending,
    String? parentTransactionId,
    List<Installment>? installments,
  }) {
    return Transaction(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      description: description ?? this.description,
      totalAmount: totalAmount ?? this.totalAmount,
      installmentAmount: installmentAmount ?? this.installmentAmount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      transactionDate: transactionDate ?? this.transactionDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isInstallment: isInstallment ?? this.isInstallment,
      totalInstallments: totalInstallments ?? this.totalInstallments,
      currentInstallment: currentInstallment ?? this.currentInstallment,
      valueInputType: valueInputType ?? this.valueInputType,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      recurrenceEndDate: recurrenceEndDate ?? this.recurrenceEndDate,
      recurrenceCount: recurrenceCount ?? this.recurrenceCount,
      notes: notes ?? this.notes,
      location: location ?? this.location,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
      isActive: isActive ?? this.isActive,
      isPending: isPending ?? this.isPending,
      parentTransactionId: parentTransactionId ?? this.parentTransactionId,
      installments: installments ?? this.installments,
    );
  }

  // Factory para criar transação simples (à vista)
  factory Transaction.simple({
    required String description,
    required double amount,
    required TransactionType type,
    required String categoryId,
    DateTime? transactionDate,
    String? notes,
  }) {
    final now = DateTime.now();
    final id = 'txn_${now.millisecondsSinceEpoch}';

    return Transaction(
      id: id,
      uuid: id,
      description: description,
      totalAmount: amount,
      installmentAmount: amount,
      type: type,
      categoryId: categoryId,
      transactionDate: transactionDate ?? now,
      createdAt: now,
      updatedAt: now,
      notes: notes,
    );
  }

  // Factory para criar transação parcelada
  factory Transaction.installments({
    required String description,
    required double amount,
    required TransactionType type,
    required String categoryId,
    required int totalInstallments,
    required ValueInputType valueInputType,
    DateTime? firstInstallmentDate,
    String? notes,
  }) {
    final now = DateTime.now();
    final id = 'txn_${now.millisecondsSinceEpoch}';

    // Calcular valores baseado no tipo de entrada
    double totalAmt, installmentAmt;
    if (valueInputType == ValueInputType.total) {
      totalAmt = amount;
      installmentAmt = amount / totalInstallments;
    } else {
      installmentAmt = amount;
      totalAmt = amount * totalInstallments;
    }

    return Transaction(
      id: id,
      uuid: id,
      description: description,
      totalAmount: totalAmt,
      installmentAmount: installmentAmt,
      type: type,
      categoryId: categoryId,
      transactionDate: firstInstallmentDate ?? now,
      createdAt: now,
      updatedAt: now,
      isInstallment: true,
      totalInstallments: totalInstallments,
      valueInputType: valueInputType,
      notes: notes,
    );
  }

  // Helpers
  double get displayAmount => isInstallment ? installmentAmount : totalAmount;
  String get formattedAmount =>
      'R\$ ${displayAmount.toStringAsFixed(2).replaceAll('.', ',')}';
  String get typeIcon => type.icon;
  String get displayDate =>
      '${transactionDate.day.toString().padLeft(2, '0')}/${transactionDate.month.toString().padLeft(2, '0')}/${transactionDate.year}';
  bool get hasInstallments => isInstallment && totalInstallments > 1;
  String get installmentDisplay =>
      hasInstallments ? '($currentInstallment/$totalInstallments)' : '';
  bool get isRecurring => recurrenceType != RecurrenceType.none;
  bool get isOverdue => isPending && DateTime.now().isAfter(transactionDate);

  @override
  String toString() {
    return 'Transaction(id: $id, description: $description, amount: $formattedAmount, type: ${type.label})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Transaction && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
