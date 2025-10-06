enum TransactionType {
  income('income', 'Receita', '💰'),
  expense('expense', 'Despesa', '💸');

  const TransactionType(this.value, this.label, this.icon);
  final String value;
  final String label;
  final String icon;
}

enum RecurrenceType {
  none('none', 'Não recorre'),
  daily('daily', 'Diário'),
  weekly('weekly', 'Semanal'),
  monthly('monthly', 'Mensal'),
  yearly('yearly', 'Anual');

  const RecurrenceType(this.value, this.label);
  final String value;
  final String label;
}

enum ValueInputType {
  total('total', 'Valor Total'),
  installment('installment', 'Valor da Parcela');

  const ValueInputType(this.value, this.label);
  final String value;
  final String label;
}

class TransactionCategory {
  final String id;
  final String name;
  final String icon;
  final TransactionType type;
  final bool isCustom;
  final String? parentId;

  const TransactionCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
    this.isCustom = false,
    this.parentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'type': type.value,
      'isCustom': isCustom,
      'parentId': parentId,
    };
  }

  factory TransactionCategory.fromMap(Map<String, dynamic> map) {
    return TransactionCategory(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      icon: map['icon'] ?? '📂',
      type: TransactionType.values.firstWhere(
        (e) => e.value == map['type'],
        orElse: () => TransactionType.expense,
      ),
      isCustom: map['isCustom'] ?? false,
      parentId: map['parentId'],
    );
  }

  // Categorias padrão para despesas
  static const List<TransactionCategory> defaultExpenseCategories = [
    TransactionCategory(
      id: 'food',
      name: 'Alimentação',
      icon: '🍽️',
      type: TransactionType.expense,
    ),
    TransactionCategory(
      id: 'transport',
      name: 'Transporte',
      icon: '🚗',
      type: TransactionType.expense,
    ),
    TransactionCategory(
      id: 'home',
      name: 'Casa',
      icon: '🏠',
      type: TransactionType.expense,
    ),
    TransactionCategory(
      id: 'personal',
      name: 'Pessoal',
      icon: '👤',
      type: TransactionType.expense,
    ),
    TransactionCategory(
      id: 'entertainment',
      name: 'Lazer',
      icon: '🎮',
      type: TransactionType.expense,
    ),
    TransactionCategory(
      id: 'health',
      name: 'Saúde',
      icon: '🏥',
      type: TransactionType.expense,
    ),
    TransactionCategory(
      id: 'education',
      name: 'Educação',
      icon: '📚',
      type: TransactionType.expense,
    ),
  ];

  // Categorias padrão para receitas
  static const List<TransactionCategory> defaultIncomeCategories = [
    TransactionCategory(
      id: 'salary',
      name: 'Salário',
      icon: '💼',
      type: TransactionType.income,
    ),
    TransactionCategory(
      id: 'freelance',
      name: 'Freelance',
      icon: '💻',
      type: TransactionType.income,
    ),
    TransactionCategory(
      id: 'investment',
      name: 'Investimentos',
      icon: '📈',
      type: TransactionType.income,
    ),
    TransactionCategory(
      id: 'bonus',
      name: 'Bonificação',
      icon: '🎁',
      type: TransactionType.income,
    ),
    TransactionCategory(
      id: 'other',
      name: 'Outros',
      icon: '💰',
      type: TransactionType.income,
    ),
  ];

  static List<TransactionCategory> get allDefaultCategories => [
    ...defaultExpenseCategories,
    ...defaultIncomeCategories,
  ];
}
