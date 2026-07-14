import 'package:flutter/material.dart';

import '../models/work_order.dart';

class WorkOrderDetailScreen extends StatelessWidget {
  final WorkOrder order;

  const WorkOrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Work Order Details'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          children: [
            _infoCard('Work Order Date', _formatDate(order.date)),
            const SizedBox(height: 12),
            _infoCard('Work Type', order.workType),
            const SizedBox(height: 12),
            _infoCard('Organization', order.organization),
            if (order.remarks.isNotEmpty) ...[
              const SizedBox(height: 12),
              _infoCard('Remarks', order.remarks),
            ],
            const SizedBox(height: 12),
            _buildItemsSection(),
            const SizedBox(height: 12),
            _infoCard('Total Quantity', '${order.totalQuantity.toStringAsFixed(0)} Bags'),
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
          ...order.items.asMap().entries.map((entry) {
            final item = entry.value;
            return Padding(
              padding: EdgeInsets.only(top: entry.key > 0 ? 8 : 0),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Text(item.productName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF19243A)))),
                  Expanded(flex: 2, child: Text('${item.quantity.toStringAsFixed(0)} Bags', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF19243A)))),
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
