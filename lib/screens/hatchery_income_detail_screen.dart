import 'package:flutter/material.dart';

import '../models/hatchery_income.dart';

class HatcheryIncomeDetailScreen extends StatelessWidget {
  final HatcheryIncome income;

  const HatcheryIncomeDetailScreen({super.key, required this.income});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Hatchery Income Details'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          children: [
            _infoCard('Date', _formatDate(income.date)),
            const SizedBox(height: 12),
            _infoCard('Buyer Name', income.buyerName),
            const SizedBox(height: 12),
            _infoCard('Buyer Address', income.buyerAddress),
            if (income.remarks.isNotEmpty) ...[
              const SizedBox(height: 12),
              _infoCard('Remarks', income.remarks),
            ],
            const SizedBox(height: 12),
            _itemsCard(),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _infoCard(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF19243A))),
        ],
      ),
    );
  }

  Widget _itemsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Products', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          const SizedBox(height: 8),
          ...income.items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text(item.productName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
                Expanded(flex: 1, child: Text('${item.quantity}x', style: const TextStyle(fontSize: 13))),
                Expanded(flex: 1, child: Text('\$${item.total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13))),
              ],
            ),
          )),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('\$${income.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
