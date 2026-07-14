import 'package:flutter/material.dart';

import '../models/sale_return.dart';

class SaleReturnDetailScreen extends StatelessWidget {
  final SaleReturn saleReturn;

  const SaleReturnDetailScreen({super.key, required this.saleReturn});

  @override
  Widget build(BuildContext context) {
    final r = saleReturn;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Sale Return Details'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          children: [
            _infoCard('Return Date', _formatDate(r.date)),
            const SizedBox(height: 12),
            _infoCard('Invoice No', r.invoiceNo),
            const SizedBox(height: 12),
            _infoCard('Organization', r.organization),
            if (r.reason.isNotEmpty) ...[
              const SizedBox(height: 12),
              _infoCard('Reason', r.reason),
            ],
            const SizedBox(height: 12),
            _buildItemsSection(),
            const SizedBox(height: 12),
            _infoCard('Total Amount', '\$${r.totalAmount.toStringAsFixed(2)}'),
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
          const Text('Return Items', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          const SizedBox(height: 8),
          ...saleReturn.items.asMap().entries.map((entry) {
            final item = entry.value;
            return Padding(
              padding: EdgeInsets.only(top: entry.key > 0 ? 8 : 0),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Text(item.productName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF19243A)))),
                  Expanded(flex: 2, child: Text('\$${item.unitPrice.toStringAsFixed(0)} x ${item.quantity.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)))),
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
