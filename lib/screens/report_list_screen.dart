import 'package:flutter/material.dart';

import '../models/report_transaction.dart';

class ReportListScreen extends StatelessWidget {
  final String title;
  final bool showInvoice;
  final List<ReportTransaction> items;

  const ReportListScreen({super.key, required this.title, required this.showInvoice, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(title),
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
                return _buildRow(item, isLast);
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
      child: Row(
        children: [
          const Expanded(flex: 2, child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          if (showInvoice)
            const Expanded(flex: 2, child: Text('Invoice', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          const Expanded(flex: 3, child: Text('Organization', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          const Expanded(flex: 2, child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)), textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Widget _buildRow(ReportTransaction item, bool isLast) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(16)) : BorderRadius.zero,
        border: const Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            Expanded(flex: 2, child: Text(item.date, style: const TextStyle(fontWeight: FontWeight.w500))),
            if (showInvoice)
              Expanded(flex: 2, child: Text(item.invoice ?? '', style: const TextStyle(fontWeight: FontWeight.w500))),
            Expanded(flex: 3, child: Text(item.organization)),
            Expanded(flex: 2, child: Text(item.amount.toStringAsFixed(2), textAlign: TextAlign.right)),
          ],
        ),
      ),
    );
  }
}
