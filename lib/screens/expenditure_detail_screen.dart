import 'package:flutter/material.dart';

import '../models/expenditure.dart';

class ExpenditureDetailScreen extends StatelessWidget {
  final Expenditure expenditure;

  const ExpenditureDetailScreen({super.key, required this.expenditure});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Expenditure Details'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          children: [
            _infoCard('Expenditure Type', expenditure.type),
            const SizedBox(height: 12),
            _infoCard('Date', _formatDate(expenditure.date)),
            const SizedBox(height: 12),
            _infoCard('Payment Method', expenditure.paymentType),
            if (expenditure.bankName != null && expenditure.bankName!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _infoCard('Bank Name', expenditure.bankName!),
            ],
            const SizedBox(height: 12),
            _infoCard('Seller Name', expenditure.sellerName),
            const SizedBox(height: 12),
            _infoCard('Description', expenditure.description),
            const SizedBox(height: 12),
            _buildItemsSection(),
            const SizedBox(height: 12),
            _infoCard('Total Amount', '\$${expenditure.totalAmount.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildItemsSection() {
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
          ...expenditure.items.asMap().entries.map((entry) {
            final item = entry.value;
            return Padding(
              padding: EdgeInsets.only(top: entry.key > 0 ? 8 : 0),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Text(item.itemName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF19243A)))),
                  Expanded(flex: 2, child: Text('\$${item.saleRate.toStringAsFixed(0)} x ${item.quantity.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)))),
                  Expanded(flex: 2, child: Text('\$${item.total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF19243A)), textAlign: TextAlign.right)),
                ],
              ),
            );
          }),
        ],
      ),
    );
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
