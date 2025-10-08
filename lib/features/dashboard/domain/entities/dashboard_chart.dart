import 'package:equatable/equatable.dart';

/// Dados para gráficos do dashboard
class DashboardChart extends Equatable {
  final String id;
  final String title;
  final DashboardChartType type;
  final Map<String, double> data;
  final List<String> labels;
  final List<String> colors;
  final DateTime periodStart;
  final DateTime periodEnd;

  const DashboardChart({
    required this.id,
    required this.title,
    required this.type,
    required this.data,
    required this.labels,
    required this.colors,
    required this.periodStart,
    required this.periodEnd,
  });

  /// Total dos valores do gráfico
  double get total => data.values.fold(0.0, (sum, value) => sum + value);

  /// Maior valor do gráfico
  double get maxValue =>
      data.values.isEmpty ? 0.0 : data.values.reduce((a, b) => a > b ? a : b);

  /// Número de entradas
  int get entryCount => data.length;

  @override
  List<Object?> get props => [
    id,
    title,
    type,
    data,
    labels,
    colors,
    periodStart,
    periodEnd,
  ];
}

/// Tipos de gráfico do dashboard
enum DashboardChartType {
  pie('pie', 'Pizza'),
  bar('bar', 'Barras'),
  line('line', 'Linha'),
  area('area', 'Área');

  const DashboardChartType(this.value, this.label);
  final String value;
  final String label;
}
