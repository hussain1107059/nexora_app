import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/statement_report.dart';
import 'statement_detail_screen.dart';

class StatementReportScreen extends StatelessWidget {
  final List<StatementReport> items;

  const StatementReportScreen({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Statement'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      body: items.isEmpty
          ? const Center(child: Text('No data available', style: TextStyle(color: Colors.black54)))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              itemCount: items.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) return _buildHeader();
                final item = items[i - 1];
                final isLast = i == items.length;
                return _buildSlidableRow(context, item, isLast);
              },
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: const Row(
        children: [
          Expanded(flex: 2, child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 2, child: Text('Total Income', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)), textAlign: TextAlign.right)),
          Expanded(flex: 2, child: Text('Total Cost', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)), textAlign: TextAlign.right)),
          Expanded(flex: 2, child: Text('Profit/Loss', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)), textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Widget _buildSlidableRow(BuildContext context, StatementReport item, bool isLast) {
    final isProfit = item.profitLoss >= 0;
    return ClipRRect(
      borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(16)) : BorderRadius.zero,
      child: Slidable(
        key: ValueKey('${item.date}-statement'),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => StatementDetailScreen(report: item)),
              ),
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              icon: Icons.visibility,
              label: 'View',
            ),
          ],
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text(item.date, style: const TextStyle(fontWeight: FontWeight.w500))),
                Expanded(flex: 2, child: Text(item.totalIncome.toStringAsFixed(2), textAlign: TextAlign.right, style: const TextStyle(color: Color(0xFF065F46)))),
                Expanded(flex: 2, child: Text(item.totalCost.toStringAsFixed(2), textAlign: TextAlign.right, style: const TextStyle(color: Color(0xFF991B1B)))),
                Expanded(
                  flex: 2,
                  child: Text(
                    '${item.profitLoss.toStringAsFixed(2)} Tk',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.w600, color: isProfit ? const Color(0xFF065F46) : const Color(0xFF991B1B)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
