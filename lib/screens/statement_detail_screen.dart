import 'package:flutter/material.dart';

import '../models/statement_report.dart';

class StatementDetailScreen extends StatelessWidget {
  final StatementReport report;

  const StatementDetailScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final b = report.breakdown;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text('Statement - ${report.date}'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          children: [
            _summaryCard(),
            const SizedBox(height: 20),
            _breakdownSection(b),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard() {
    final isProfit = report.profitLoss >= 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF2563EB)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Statement Summary', style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 12),
          _summaryRow('Total Income', report.totalIncome, Colors.white),
          const SizedBox(height: 8),
          _summaryRow('Total Cost', report.totalCost, Colors.white70),
          const Divider(color: Colors.white24, height: 20),
          _summaryRow(
            isProfit ? 'Profit' : 'Loss',
            report.profitLoss,
            isProfit ? const Color(0xFF4ADE80) : const Color(0xFFF87171),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, double amount, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w500)),
        Text('${amount.toStringAsFixed(2)} Tk', style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _breakdownSection(StatementBreakdown b) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          _breakdownItem(Icons.shopping_cart_outlined, 'Sale', b.sale, const Color(0xFFDB2777)),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _breakdownItem(Icons.assignment_return_outlined, 'Sale Return', b.saleReturn, const Color(0xFF0891B2)),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _breakdownItem(Icons.local_shipping_outlined, 'Supply Amount Receive', b.supplyAmountReceive, const Color(0xFFD97706)),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _breakdownItem(Icons.payment_outlined, 'Amount Payment', b.amountPayment, const Color(0xFF2563EB)),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _breakdownItem(Icons.receipt_outlined, 'Expenditure', b.expenditure, const Color(0xFFEA580C)),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _breakdownItem(Icons.add_circle_outlined, 'Other Income', b.otherIncome, const Color(0xFF16A34A)),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _breakdownItem(Icons.money_off_outlined, 'Withdrawal', b.withdrawal, const Color(0xFFB91C1C)),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _breakdownItem(Icons.egg_outlined, 'Hatchery Income', b.hatcheryIncome, const Color(0xFF7C3AED)),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _breakdownItem(Icons.egg_outlined, 'Hatchery Expense', b.hatcheryExpense, const Color(0xFFEA580C)),
        ],
      ),
    );
  }

  Widget _breakdownItem(IconData icon, String label, double amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF334155)))),
          Text('${amount.toStringAsFixed(2)} Tk', style: TextStyle(fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}
