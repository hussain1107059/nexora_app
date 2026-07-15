import 'package:flutter/material.dart';

import '../models/product_stock_entry.dart';

class ProductStockEntryDetailScreen extends StatelessWidget {
  final ProductStockEntry entry;

  const ProductStockEntryDetailScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Stock Entry Details'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          children: [
            _infoCard('Production Date', _formatDate(entry.date)),
            const SizedBox(height: 12),
            _infoCard('Production Chalan', entry.productionChalan),
            const SizedBox(height: 12),
            _infoCard('Manufacture Cost', '${entry.manufactureCost.toStringAsFixed(0)} Tk'),
            const SizedBox(height: 12),
            _infoCard('General Cost', '${entry.generalCost.toStringAsFixed(0)} Tk'),
            const SizedBox(height: 12),
            _buildItemsSection(),
            const SizedBox(height: 12),
            _infoCard('Total Quantity', '${entry.totalQuantity.toStringAsFixed(0)} Units'),
            _infoCard('Total Cost', '${entry.totalCost.toStringAsFixed(0)} Tk'),
            if (entry.remarks.isNotEmpty) ...[
              const SizedBox(height: 12),
              _infoCard('Remarks', entry.remarks),
            ],
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
          const Row(
            children: [
              Expanded(flex: 3, child: Text('Category', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
              Expanded(flex: 2, child: Text('Qty', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
              Expanded(flex: 2, child: Text('Cost', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
            ],
          ),
          const Divider(height: 12),
          ...entry.items.asMap().entries.map((e) {
            final item = e.value;
            return Padding(
              padding: EdgeInsets.only(top: e.key > 0 ? 6 : 0),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Text(item.productCategory, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF19243A)))),
                  Expanded(flex: 2, child: Text(item.productQuantity.toStringAsFixed(0), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF19243A)))),
                  Expanded(flex: 2, child: Text('${item.productCosting.toStringAsFixed(0)} Tk', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF19243A)))),
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
