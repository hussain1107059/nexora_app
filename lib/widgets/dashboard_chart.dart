import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardChart extends StatefulWidget {
  const DashboardChart({super.key});

  @override
  State<DashboardChart> createState() => _DashboardChartState();
}

class _DashboardChartState extends State<DashboardChart> {
  String _selectedFilter = 'Today';
  DateTime? _selectedDate;

  static const _labels = ['Sale', 'Supply', 'Income', 'Cost', 'Profit'];
  static const _barColors = [
    Color(0xFF3B82F6),
    Color(0xFFF59E0B),
    Color(0xFF10B981),
    Color(0xFFEF4444),
    Color(0xFF8B5CF6),
  ];

  List<double> _getValues() {
    if (_selectedFilter == 'Today') {
      return [45000.0, 32000.0, 28000.0, 15000.0, 5000.0];
    } else if (_selectedFilter == 'Last 7 Days') {
      return [285000.0, 210000.0, 175000.0, 95000.0, 32000.0];
    } else {
      return [38000.0, 27000.0, 22000.0, 12000.0, 4000.0];
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
        _selectedFilter = 'Date';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final values = _getValues();
    final displayDate = _selectedDate != null
        ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
        : 'Date';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF19243A))),
              const SizedBox(width: 8),
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                  ...['Today', 'Last 7 Days'].map((f) => Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: ChoiceChip(
                      label: Text(f, style: const TextStyle(fontSize: 11)),
                      selected: _selectedFilter == f,
                      selectedColor: const Color(0xFF2563EB),
                      labelStyle: TextStyle(color: _selectedFilter == f ? Colors.white : const Color(0xFF475569), fontSize: 11),
                      onSelected: (v) => setState(() => _selectedFilter = f),
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  )),
                  const SizedBox(width: 6),
                  ChoiceChip(
                    label: Text(displayDate, style: const TextStyle(fontSize: 11)),
                    selected: _selectedFilter == 'Date',
                    selectedColor: const Color(0xFF2563EB),
                    labelStyle: TextStyle(color: _selectedFilter == 'Date' ? Colors.white : const Color(0xFF475569), fontSize: 11),
                    onSelected: (_) => _pickDate(),
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: values.reduce((a, b) => a > b ? a : b) * 1.3,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem('\$${rod.toY.toStringAsFixed(0)}', const TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= _labels.length) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(_labels[idx], style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: values.reduce((a, b) => a > b ? a : b) / 4,
                  getDrawingHorizontalLine: (value) => const FlLine(color: Color(0xFFE2E8F0), strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barGroups: values.asMap().entries.map((e) => BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value,
                      color: _barColors[e.key],
                      width: 24,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                    ),
                  ],
                )).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
