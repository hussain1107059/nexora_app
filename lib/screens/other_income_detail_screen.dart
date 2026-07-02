import 'package:flutter/material.dart';

import '../models/other_income.dart';

class OtherIncomeDetailScreen extends StatelessWidget {
  final OtherIncome income;

  const OtherIncomeDetailScreen({super.key, required this.income});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Other Income Details'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          children: [
            _infoCard('Income Source', income.incomeSource),
            const SizedBox(height: 12),
            _infoCard('Consumer Name', income.consumerName),
            const SizedBox(height: 12),
            _infoCard('Date', _formatDate(income.date)),
            const SizedBox(height: 12),
            _infoCard('Payment Method', income.paymentMethod),
            if (income.bankName != null && income.bankName!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _infoCard('Bank Name', income.bankName!),
            ],
            const SizedBox(height: 12),
            _infoCard('Amount', '\$${income.amount.toStringAsFixed(2)}'),
            if (income.remarks.isNotEmpty) ...[
              const SizedBox(height: 12),
              _infoCard('Remarks', income.remarks),
            ],
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
}
