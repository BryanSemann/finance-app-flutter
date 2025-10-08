import 'dart:convert';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/financial_summary_model.dart';
import '../models/dashboard_chart_model.dart';
import '../models/recent_transaction_model.dart';
import 'dashboard_local_datasource.dart';

/// Implementação do data source local do dashboard
class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  final LocalStorage _storage;

  // Chaves de cache
  static const String _financialSummaryPrefix = 'dashboard_summary_';
  static const String _chartsPrefix = 'dashboard_charts_';
  static const String _recentTransactionsKey = 'dashboard_recent_transactions';
  static const String _cacheTimestampSuffix = '_timestamp';

  // Tempo de expiração do cache em milissegundos (30 minutos)
  static const int _cacheExpirationMs = 30 * 60 * 1000;

  DashboardLocalDataSourceImpl(this._storage);

  @override
  Future<void> cacheFinancialSummary(
    FinancialSummaryModel summary,
    DateTime month,
  ) async {
    try {
      final key = '$_financialSummaryPrefix${month.year}_${month.month}';
      final json = jsonEncode(summary.toJson());

      await _storage.setString(key, json);
      await _storage.setInt(
        '$key$_cacheTimestampSuffix',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      throw CacheException(message: 'Erro ao cachear resumo financeiro: $e');
    }
  }

  @override
  Future<FinancialSummaryModel?> getCachedFinancialSummary(
    DateTime month,
  ) async {
    try {
      final key = '$_financialSummaryPrefix${month.year}_${month.month}';

      // Verificar se o cache expirou
      if (await _isCacheExpired(key)) {
        await _removeCacheEntry(key);
        return null;
      }

      final json = await _storage.getString(key);
      if (json == null) return null;

      final data = jsonDecode(json) as Map<String, dynamic>;
      return FinancialSummaryModel.fromJson(data);
    } catch (e) {
      throw CacheException(
        message: 'Erro ao recuperar resumo financeiro do cache: $e',
      );
    }
  }

  @override
  Future<void> cacheDashboardCharts(
    List<DashboardChartModel> charts,
    String key,
  ) async {
    try {
      final cacheKey = '$_chartsPrefix$key';
      final json = jsonEncode(charts.map((chart) => chart.toJson()).toList());

      await _storage.setString(cacheKey, json);
      await _storage.setInt(
        '$cacheKey$_cacheTimestampSuffix',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      throw CacheException(message: 'Erro ao cachear gráficos: $e');
    }
  }

  @override
  Future<List<DashboardChartModel>?> getCachedDashboardCharts(
    String key,
  ) async {
    try {
      final cacheKey = '$_chartsPrefix$key';

      // Verificar se o cache expirou
      if (await _isCacheExpired(cacheKey)) {
        await _removeCacheEntry(cacheKey);
        return null;
      }

      final json = await _storage.getString(cacheKey);
      if (json == null) return null;

      final List<dynamic> data = jsonDecode(json) as List<dynamic>;
      return data
          .map(
            (json) =>
                DashboardChartModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw CacheException(message: 'Erro ao recuperar gráficos do cache: $e');
    }
  }

  @override
  Future<void> cacheRecentTransactions(
    List<RecentTransactionModel> transactions,
  ) async {
    try {
      final json = jsonEncode(transactions.map((t) => t.toJson()).toList());

      await _storage.setString(_recentTransactionsKey, json);
      await _storage.setInt(
        '$_recentTransactionsKey$_cacheTimestampSuffix',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      throw CacheException(message: 'Erro ao cachear transações recentes: $e');
    }
  }

  @override
  Future<List<RecentTransactionModel>?> getCachedRecentTransactions() async {
    try {
      // Verificar se o cache expirou
      if (await _isCacheExpired(_recentTransactionsKey)) {
        await _removeCacheEntry(_recentTransactionsKey);
        return null;
      }

      final json = await _storage.getString(_recentTransactionsKey);
      if (json == null) return null;

      final List<dynamic> data = jsonDecode(json) as List<dynamic>;
      return data
          .map(
            (json) =>
                RecentTransactionModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Erro ao recuperar transações do cache: $e',
      );
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      // Esta implementação simples remove todas as chaves conhecidas
      // Em uma implementação mais sofisticada, poderíamos ter um índice de chaves
      final keys = [
        _recentTransactionsKey,
        '$_recentTransactionsKey$_cacheTimestampSuffix',
      ];

      for (final key in keys) {
        await _storage.remove(key);
      }

      // Note: Para uma implementação completa, seria necessário manter um
      // registro de todas as chaves de cache ou usar um padrão de prefixo
      // para poder remover todas as entradas relacionadas ao dashboard
    } catch (e) {
      throw CacheException(message: 'Erro ao limpar cache: $e');
    }
  }

  @override
  Future<void> clearExpiredCache() async {
    try {
      // Esta é uma implementação simplificada
      // Em uma versão mais robusta, manteriamos um índice de todas as chaves

      // Por enquanto, apenas verificamos as chaves conhecidas
      await _checkAndRemoveExpired(_recentTransactionsKey);

      // Para as chaves dinâmicas (summary e charts), seria necessário
      // manter um registro ou usar uma estratégia diferente de armazenamento
    } catch (e) {
      throw CacheException(message: 'Erro ao limpar cache expirado: $e');
    }
  }

  /// Verifica se uma entrada do cache expirou
  Future<bool> _isCacheExpired(String key) async {
    final timestampKey = '$key$_cacheTimestampSuffix';
    final timestamp = await _storage.getInt(timestampKey);

    if (timestamp == null) return true;

    final now = DateTime.now().millisecondsSinceEpoch;
    return (now - timestamp) > _cacheExpirationMs;
  }

  /// Remove uma entrada do cache junto com seu timestamp
  Future<void> _removeCacheEntry(String key) async {
    await _storage.remove(key);
    await _storage.remove('$key$_cacheTimestampSuffix');
  }

  /// Verifica e remove se expirado
  Future<void> _checkAndRemoveExpired(String key) async {
    if (await _isCacheExpired(key)) {
      await _removeCacheEntry(key);
    }
  }
}
