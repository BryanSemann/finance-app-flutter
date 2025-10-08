import '../../domain/entities/dashboard_chart.dart';

/// Model para gráficos do dashboard
class DashboardChartModel extends DashboardChart {
  const DashboardChartModel({
    required super.id,
    required super.title,
    required super.type,
    required super.data,
    required super.labels,
    required super.colors,
    required super.periodStart,
    required super.periodEnd,
  });

  /// Cria a partir de JSON da API
  factory DashboardChartModel.fromJson(Map<String, dynamic> json) {
    return DashboardChartModel(
      id: json['id'] as String,
      title: json['title'] as String,
      type: DashboardChartType.values.firstWhere(
        (type) => type.value == json['type'],
        orElse: () => DashboardChartType.pie,
      ),
      data: Map<String, double>.from(
        (json['data'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        ),
      ),
      labels: List<String>.from(json['labels'] as List? ?? []),
      colors: List<String>.from(json['colors'] as List? ?? []),
      periodStart: DateTime.parse(json['period_start'] as String),
      periodEnd: DateTime.parse(json['period_end'] as String),
    );
  }

  /// Converte para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type.value,
      'data': data,
      'labels': labels,
      'colors': colors,
      'period_start': periodStart.toIso8601String(),
      'period_end': periodEnd.toIso8601String(),
    };
  }

  /// Cria a partir da entidade do domínio
  factory DashboardChartModel.fromEntity(DashboardChart entity) {
    return DashboardChartModel(
      id: entity.id,
      title: entity.title,
      type: entity.type,
      data: entity.data,
      labels: entity.labels,
      colors: entity.colors,
      periodStart: entity.periodStart,
      periodEnd: entity.periodEnd,
    );
  }

  /// Converte para entidade do domínio
  DashboardChart toEntity() {
    return DashboardChart(
      id: id,
      title: title,
      type: type,
      data: data,
      labels: labels,
      colors: colors,
      periodStart: periodStart,
      periodEnd: periodEnd,
    );
  }
}
