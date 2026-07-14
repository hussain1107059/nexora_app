import 'package:flutter/material.dart';

import '../models/supply_product.dart';

class SupplyProductDetailScreen extends StatelessWidget {
  final SupplyProduct product;

  const SupplyProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Supply Details'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          children: [
            _infoCard('Chalan Date', _formatDate(product.chalanDate)),
            const SizedBox(height: 12),
            _infoCard('Chalan No', product.chalanNo),
            if (product.partyNo.isNotEmpty) ...[
              const SizedBox(height: 12),
              _infoCard('Party No', product.partyNo),
            ],
            if (product.serialNo.isNotEmpty) ...[
              const SizedBox(height: 12),
              _infoCard('Serial No', product.serialNo),
            ],
            const SizedBox(height: 12),
            _infoCard('Supplier', product.supplier),
            const SizedBox(height: 12),
            _infoCard('Truck Number', product.truckNumber),
            if (product.remarks.isNotEmpty) ...[
              const SizedBox(height: 12),
              _infoCard('Remarks', product.remarks),
            ],
            const SizedBox(height: 12),
            _buildItemsSection(),
            const SizedBox(height: 12),
            _infoCard('Total Amount', '\$${product.totalAmount.toStringAsFixed(2)}'),
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
          ...product.items.asMap().entries.map((entry) {
            final item = entry.value;
            return Padding(
              padding: EdgeInsets.only(top: entry.key > 0 ? 8 : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(flex: 3, child: Text(item.productName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF19243A)))),
                      Expanded(flex: 2, child: Text('\$${item.buyRate.toStringAsFixed(0)}/KG', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)))),
                      Expanded(flex: 2, child: Text('\$${item.total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF19243A)), textAlign: TextAlign.right)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.numberOfBags} bags | ${item.quantityKg.toStringAsFixed(0)} KG | ${item.weightPerBagMon.toStringAsFixed(0)} KG/bag | ${item.warehouse}',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
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
