import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../shared/models/transaction.dart';
import '../../shared/models/transaction_category.dart';
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
            icon: const Icon(Icons.filter_list),
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
              Colors.green,
              Icons.arrow_upward,
            ),
            _buildSummaryItem(
              'Despesas',
              controller.totalExpenses,
              Colors.red,
              Icons.arrow_downward,
            ),
            _buildSummaryItem(
              'Saldo',
              controller.balance,
              controller.balance >= 0 ? Colors.green : Colors.red,
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
    final color = isIncome ? Colors.green : Colors.red;
    final sign = isIncome ? '+' : '-';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
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
          const Icon(Icons.receipt_long, size: 64, color: Colors.grey),
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
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
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
            leading: const Icon(Icons.delete, color: Colors.red),
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

  void _showFilters() {
    // TODO: Implementar tela de filtros
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filtros - Em desenvolvimento')),
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
