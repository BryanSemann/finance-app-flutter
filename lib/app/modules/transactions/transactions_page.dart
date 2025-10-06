import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../shared/models/transaction.dart';
import '../../shared/models/transaction_category.dart';
import '../../shared/theme/app_theme.dart';
import 'transactions_controller.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late final TransactionsController controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller = Modular.get<TransactionsController>();
    controller.addListener(_onControllerChange);
    _scrollController.addListener(_onScroll);

    // Carregar dados iniciais
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initialize();
    });
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerChange);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onControllerChange() {
    setState(() {});
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      controller.loadTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transações'),
        actions: [
          IconButton(
            onPressed: _showFilters,
            icon: Badge(
              isLabelVisible: _hasActiveFilters(),
              smallSize: 8,
              child: const Icon(Icons.filter_list),
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'quick_filters',
                child: ListTile(
                  leading: Icon(Icons.flash_on),
                  title: Text('Filtros Rápidos'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'today',
                child: const ListTile(
                  leading: Icon(Icons.today),
                  title: Text('Hoje'),
                  contentPadding: EdgeInsets.zero,
                ),
                onTap: () => _applyQuickFilter('today'),
              ),
              PopupMenuItem(
                value: 'week',
                child: const ListTile(
                  leading: Icon(Icons.date_range),
                  title: Text('Esta semana'),
                  contentPadding: EdgeInsets.zero,
                ),
                onTap: () => _applyQuickFilter('week'),
              ),
              PopupMenuItem(
                value: 'month',
                child: const ListTile(
                  leading: Icon(Icons.calendar_month),
                  title: Text('Este mês'),
                  contentPadding: EdgeInsets.zero,
                ),
                onTap: () => _applyQuickFilter('month'),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'income',
                child: const ListTile(
                  leading: Icon(
                    Icons.arrow_upward,
                    color: AppTheme.incomeColor,
                  ),
                  title: Text('Apenas receitas'),
                  contentPadding: EdgeInsets.zero,
                ),
                onTap: () => _applyQuickFilter('income'),
              ),
              PopupMenuItem(
                value: 'expense',
                child: const ListTile(
                  leading: Icon(
                    Icons.arrow_downward,
                    color: AppTheme.expenseColor,
                  ),
                  title: Text('Apenas despesas'),
                  contentPadding: EdgeInsets.zero,
                ),
                onTap: () => _applyQuickFilter('expense'),
              ),
            ],
          ),
          IconButton(onPressed: _showSearch, icon: const Icon(Icons.search)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createTransaction,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (controller.isLoading && controller.transactions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.hasError && controller.transactions.isEmpty) {
      return _buildErrorState();
    }

    if (controller.transactions.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildSummaryCard(),
        if (_hasActiveFilters()) _buildActiveFilters(),
        Expanded(child: _buildTransactionsList()),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem(
              'Receitas',
              controller.totalIncome,
              AppTheme.incomeColor,
              Icons.arrow_upward,
            ),
            _buildSummaryItem(
              'Despesas',
              controller.totalExpenses,
              AppTheme.expenseColor,
              Icons.arrow_downward,
            ),
            _buildSummaryItem(
              'Saldo',
              controller.balance,
              controller.balance >= 0
                  ? AppTheme.incomeColor
                  : AppTheme.expenseColor,
              controller.balance >= 0 ? Icons.trending_up : Icons.trending_down,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    double value,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(
          'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filtros ativos:',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
              ),
              TextButton(
                onPressed: controller.clearFilters,
                child: const Text('Limpar todos'),
              ),
            ],
          ),
          Wrap(spacing: 8, runSpacing: 4, children: _buildFilterChips()),
        ],
      ),
    );
  }

  List<Widget> _buildFilterChips() {
    final List<Widget> chips = [];

    // Filtro de data
    if (controller.startDate != null || controller.endDate != null) {
      String dateText = '';
      if (controller.startDate != null && controller.endDate != null) {
        dateText =
            '${_formatDate(controller.startDate!)} - ${_formatDate(controller.endDate!)}';
      } else if (controller.startDate != null) {
        dateText = 'A partir de ${_formatDate(controller.startDate!)}';
      } else if (controller.endDate != null) {
        dateText = 'Até ${_formatDate(controller.endDate!)}';
      }

      chips.add(
        Chip(
          label: Text(dateText),
          onDeleted: () => controller.applyFilters(
            type: controller.filterType,
            categoryId: controller.filterCategoryId,
          ),
          deleteIcon: const Icon(Icons.close, size: 16),
        ),
      );
    }

    // Filtro de tipo
    if (controller.filterType != null) {
      chips.add(
        Chip(
          label: Text(
            controller.filterType == TransactionType.income
                ? 'Receitas'
                : 'Despesas',
          ),
          onDeleted: () => controller.applyFilters(
            startDate: controller.startDate,
            endDate: controller.endDate,
            categoryId: controller.filterCategoryId,
          ),
          deleteIcon: const Icon(Icons.close, size: 16),
        ),
      );
    }

    // Filtro de categoria
    if (controller.filterCategoryId != null) {
      final category = controller.getCategoryById(controller.filterCategoryId!);
      if (category != null) {
        chips.add(
          Chip(
            avatar: Text(category.icon, style: const TextStyle(fontSize: 12)),
            label: Text(category.name),
            onDeleted: () => controller.applyFilters(
              startDate: controller.startDate,
              endDate: controller.endDate,
              type: controller.filterType,
            ),
            deleteIcon: const Icon(Icons.close, size: 16),
          ),
        );
      }
    }

    return chips;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildTransactionsList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount:
          controller.transactions.length + (controller.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= controller.transactions.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final transaction = controller.transactions[index];
        final category = controller.getCategoryById(transaction.categoryId);

        return _buildTransactionTile(transaction, category);
      },
    );
  }

  Widget _buildTransactionTile(
    Transaction transaction,
    TransactionCategory? category,
  ) {
    final isIncome = transaction.type == TransactionType.income;
    final color = AppTheme.getTransactionColor(isIncome);
    final sign = isIncome ? '+' : '-';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Text(
            category?.icon ?? (isIncome ? '💰' : '💸'),
            style: const TextStyle(fontSize: 20),
          ),
        ),
        title: Text(
          transaction.description,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category?.name ?? 'Sem categoria'),
            Text(
              transaction.displayDate,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$sign${transaction.formattedAmount}',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (transaction.hasInstallments)
              Text(
                transaction.installmentDisplay,
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        onTap: () => _editTransaction(transaction),
        onLongPress: () => _showTransactionOptions(transaction),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 64, color: Colors.grey.shade600),
          const SizedBox(height: 16),
          Text(
            'Nenhuma transação encontrada',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Toque no botão + para adicionar sua primeira transação',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _createTransaction,
            icon: const Icon(Icons.add),
            label: const Text('Adicionar Transação'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppTheme.expenseColor),
          const SizedBox(height: 16),
          Text(
            'Erro ao carregar transações',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            controller.errorMessage ?? 'Erro desconhecido',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => controller.loadTransactions(refresh: true),
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar Novamente'),
          ),
        ],
      ),
    );
  }

  void _createTransaction() {
    Modular.to.pushNamed('/transactions/create');
  }

  void _editTransaction(Transaction transaction) {
    Modular.to.pushNamed('/transactions/edit/${transaction.id}');
  }

  void _showTransactionOptions(Transaction transaction) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Editar'),
            onTap: () {
              Navigator.pop(context);
              _editTransaction(transaction);
            },
          ),
          ListTile(
            leading: const Icon(Icons.copy),
            title: const Text('Duplicar'),
            onTap: () {
              Navigator.pop(context);
              controller.duplicateTransaction(transaction.id);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete, color: AppTheme.expenseColor),
            title: const Text('Excluir'),
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirmation(transaction);
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text(
          'Deseja excluir a transação "${transaction.description}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteTransaction(transaction.id);
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  bool _hasActiveFilters() {
    return controller.startDate != null ||
        controller.endDate != null ||
        controller.filterType != null ||
        controller.filterCategoryId != null;
  }

  void _applyQuickFilter(String filterType) {
    DateTime? startDate;
    DateTime? endDate;
    TransactionType? type;

    final now = DateTime.now();

    switch (filterType) {
      case 'today':
        startDate = DateTime(now.year, now.month, now.day);
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case 'week':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        startDate = DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day,
        );
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case 'month':
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        break;
      case 'income':
        type = TransactionType.income;
        break;
      case 'expense':
        type = TransactionType.expense;
        break;
    }

    controller.applyFilters(
      startDate: startDate,
      endDate: endDate,
      type: type,
      categoryId: null,
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterBottomSheet(controller: controller),
    );
  }

  void _showSearch() {
    showSearch(
      context: context,
      delegate: TransactionSearchDelegate(controller),
    );
  }
}

class TransactionSearchDelegate extends SearchDelegate {
  final TransactionsController controller;

  TransactionSearchDelegate(this.controller);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      controller.searchTransactions(query);
    }
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.transactions.isEmpty) {
          return const Center(child: Text('Nenhuma transação encontrada'));
        }

        return ListView.builder(
          itemCount: controller.transactions.length,
          itemBuilder: (context, index) {
            final transaction = controller.transactions[index];
            final category = controller.getCategoryById(transaction.categoryId);

            return ListTile(
              leading: Text(category?.icon ?? '💰'),
              title: Text(transaction.description),
              subtitle: Text(category?.name ?? 'Sem categoria'),
              trailing: Text(transaction.formattedAmount),
              onTap: () {
                close(context, transaction);
                Modular.to.pushNamed('/transactions/edit/${transaction.id}');
              },
            );
          },
        );
      },
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  final TransactionsController controller;

  const FilterBottomSheet({super.key, required this.controller});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late DateTime? startDate;
  late DateTime? endDate;
  late TransactionType? selectedType;
  late String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    // Inicializar com filtros atuais
    startDate = widget.controller.startDate;
    endDate = widget.controller.endDate;
    selectedType = widget.controller.filterType;
    selectedCategoryId = widget.controller.filterCategoryId;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filtros',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(onPressed: _clearFilters, child: const Text('Limpar')),
            ],
          ),
          const SizedBox(height: 24),

          // Filtro por período
          _buildDateFilters(),
          const SizedBox(height: 24),

          // Filtro por tipo
          _buildTypeFilter(),
          const SizedBox(height: 24),

          // Filtro por categoria
          _buildCategoryFilter(),
          const SizedBox(height: 32),

          // Botões de ação
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  child: const Text('Aplicar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Período',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _selectDate(true),
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  startDate != null ? _formatDate(startDate!) : 'Data inicial',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _selectDate(false),
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  endDate != null ? _formatDate(endDate!) : 'Data final',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Botões de período pré-definido
        Wrap(
          spacing: 8,
          children: [
            FilterChip(
              label: const Text('Hoje'),
              selected: _isToday(),
              onSelected: (_) => _setToday(),
            ),
            FilterChip(
              label: const Text('Esta semana'),
              selected: _isThisWeek(),
              onSelected: (_) => _setThisWeek(),
            ),
            FilterChip(
              label: const Text('Este mês'),
              selected: _isThisMonth(),
              onSelected: (_) => _setThisMonth(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: FilterChip(
                label: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      size: 16,
                      color: AppTheme.incomeColor,
                    ),
                    SizedBox(width: 4),
                    Text('Receitas'),
                  ],
                ),
                selected: selectedType == TransactionType.income,
                onSelected: (selected) {
                  setState(() {
                    selectedType = selected ? TransactionType.income : null;
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilterChip(
                label: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_downward,
                      size: 16,
                      color: AppTheme.expenseColor,
                    ),
                    SizedBox(width: 4),
                    Text('Despesas'),
                  ],
                ),
                selected: selectedType == TransactionType.expense,
                onSelected: (selected) {
                  setState(() {
                    selectedType = selected ? TransactionType.expense : null;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categoria',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.controller.categories.length,
            itemBuilder: (context, index) {
              final category = widget.controller.categories[index];
              final isSelected = selectedCategoryId == category.id;

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FilterChip(
                  avatar: Text(
                    category.icon,
                    style: const TextStyle(fontSize: 16),
                  ),
                  label: Text(category.name),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      selectedCategoryId = selected ? category.id : null;
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isStartDate ? startDate : endDate) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
          // Se a data final for anterior à inicial, ajustar
          if (endDate != null && endDate!.isBefore(picked)) {
            endDate = picked;
          }
        } else {
          endDate = picked;
          // Se a data inicial for posterior à final, ajustar
          if (startDate != null && startDate!.isAfter(picked)) {
            startDate = picked;
          }
        }
      });
    }
  }

  void _setToday() {
    setState(() {
      final now = DateTime.now();
      startDate = DateTime(now.year, now.month, now.day);
      endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    });
  }

  void _setThisWeek() {
    setState(() {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      startDate = DateTime(
        startOfWeek.year,
        startOfWeek.month,
        startOfWeek.day,
      );
      endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    });
  }

  void _setThisMonth() {
    setState(() {
      final now = DateTime.now();
      startDate = DateTime(now.year, now.month, 1);
      endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    });
  }

  bool _isToday() {
    if (startDate == null || endDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return startDate!.isAtSameMomentAs(today) && endDate!.day == today.day;
  }

  bool _isThisWeek() {
    if (startDate == null || endDate == null) return false;
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekDay = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );
    return startDate!.isAtSameMomentAs(startOfWeekDay);
  }

  bool _isThisMonth() {
    if (startDate == null || endDate == null) return false;
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    return startDate!.isAtSameMomentAs(startOfMonth) &&
        endDate!.month == now.month;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _clearFilters() {
    setState(() {
      startDate = null;
      endDate = null;
      selectedType = null;
      selectedCategoryId = null;
    });
  }

  void _applyFilters() {
    widget.controller.applyFilters(
      startDate: startDate,
      endDate: endDate,
      type: selectedType,
      categoryId: selectedCategoryId,
    );
    Navigator.of(context).pop();
  }
}
