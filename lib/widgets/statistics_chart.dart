import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

enum ChartType { pie, bar, line }

class StatisticsChart extends StatelessWidget {
  final Map<String, dynamic> data;
  final ChartType chartType;

  const StatisticsChart({
    super.key,
    required this.data,
    required this.chartType,
  });

  @override
  Widget build(BuildContext context) {
    switch (chartType) {
      case ChartType.pie:
        return _buildPieChart(context);
      case ChartType.bar:
        return _buildBarChart(context);
      case ChartType.line:
        return _buildLineChart(context);
    }
  }

  Widget _buildPieChart(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('Tidak ada data'));
    }

    final total = data.values.fold(
      0,
      (sum, count) => sum + (count is int ? count : 0),
    );
    final colors = _getChartColors();

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 180, maxHeight: 200),
      child: PieChart(
        PieChartData(
          sections: data.entries.map((entry) {
            final index = data.keys.toList().indexOf(entry.key);
            final intValue = entry.value is int ? entry.value as int : 0;
            final percentage = total > 0 ? (intValue / total) * 100 : 0.0;
            return PieChartSectionData(
              value: intValue.toDouble(),
              title: '${percentage.toStringAsFixed(1)}%',
              color: colors[index % colors.length],
              radius: 60,
              titleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList(),
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }

  Widget _buildBarChart(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('Tidak ada data'));
    }

    final maxValue = data.values.isNotEmpty
        ? data.values
              .map((v) => v is int ? v : 0)
              .reduce((a, b) => a > b ? a : b)
        : 1;
    final colors = _getChartColors();

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 180, maxHeight: 200),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxValue.toDouble(),
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < data.length) {
                    return Text(
                      data.keys.elementAt(index),
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: data.entries.map((entry) {
            final index = data.keys.toList().indexOf(entry.key);
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: (entry.value is int ? entry.value as int : 0).toDouble(),
                  color: colors[index % colors.length],
                  width: 20,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildLineChart(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('Tidak ada data'));
    }

    final colors = _getChartColors();
    final spots = data.entries.map((entry) {
      final index = data.keys.toList().indexOf(entry.key);
      return FlSpot(
        index.toDouble(),
        (entry.value is int ? entry.value as int : 0).toDouble(),
      );
    }).toList();

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 180, maxHeight: 200),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < data.length) {
                    return Text(
                      data.keys.elementAt(index),
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: colors.first,
              barWidth: 3,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: colors.first.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _getChartColors() {
    return [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
  }
}
