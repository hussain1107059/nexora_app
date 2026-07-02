import 'package:flutter/material.dart';

import '../models/payment.dart';

class PaymentDetailScreen extends StatelessWidget {
  final Payment payment;

  const PaymentDetailScreen({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Payment Details'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          children: [
            _infoCard('Transaction ID', payment.transId),
            const SizedBox(height: 12),
            _infoCard('Date', _formatDate(payment.date)),
            const SizedBox(height: 12),
            _infoCard('Transaction Type', payment.transactionType),
            const SizedBox(height: 12),
            _infoCard('Payment Type', payment.paymentType),
            const SizedBox(height: 12),
            _infoCard('Bank Name', payment.bankName),
            const SizedBox(height: 12),
            _infoCard('Type', payment.type),
            const SizedBox(height: 12),
            _infoCard('Name', payment.selectName),
            const SizedBox(height: 12),
            _infoCard('Amount', '\$${payment.amount.toStringAsFixed(2)}'),
            if (payment.description.isNotEmpty) ...[
              const SizedBox(height: 12),
              _infoCard('Description', payment.description),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
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
