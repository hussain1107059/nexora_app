import 'package:flutter/material.dart';

import '../models/stock_item.dart';

class StockDetailScreen extends StatelessWidget {
  final StockItem item;

  const StockDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(item.productName),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF2563EB)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                item.productName,
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            _buildTableHeader(),
            Expanded(
              child: ListView.builder(
                itemCount: item.warehouses.length,
                itemBuilder: (context, index) {
                  final w = item.warehouses[index];
                  final isLast = index == item.warehouses.length - 1;
                  return _buildTableRow(w, isLast);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: const Row(
        children: [
          Expanded(flex: 3, child: Text('Warehouse', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 2, child: Text('Qty (Bag)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)), textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text('Qty (Mon)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)), textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text('Qty (Kg)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)), textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _buildTableRow(WarehouseStock w, bool isLast) {
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
            Expanded(flex: 3, child: Text(w.warehouse, style: const TextStyle(fontWeight: FontWeight.w500))),
            Expanded(flex: 2, child: Text(w.quantityBag.toStringAsFixed(2), textAlign: TextAlign.center)),
            Expanded(flex: 2, child: Text(w.quantityMon.toStringAsFixed(2), textAlign: TextAlign.center)),
            Expanded(flex: 2, child: Text(w.quantityKg.toStringAsFixed(2), textAlign: TextAlign.center)),
          ],
        ),
      ),
    );
  }
}
