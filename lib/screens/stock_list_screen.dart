import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/stock_item.dart';
import 'stock_detail_screen.dart';

class StockListScreen extends StatelessWidget {
  final String title;
  final List<StockItem> items;

  const StockListScreen({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      body: items.isEmpty
          ? const Center(child: Text('No data available', style: TextStyle(color: Colors.black54)))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              itemCount: items.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) return _buildHeader();
                final item = items[i - 1];
                final isLast = i == items.length;
                return _buildSlidableRow(context, item, isLast);
              },
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: const Row(
        children: [
          Expanded(flex: 3, child: Text('Product', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 2, child: Text('Qty (Bag)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)), textAlign: TextAlign.center),
          ),
          Expanded(flex: 2, child: Text('Qty (Mon)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)), textAlign: TextAlign.center),
          ),
          Expanded(flex: 2, child: Text('Qty (Kg)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)), textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  Widget _buildSlidableRow(BuildContext context, StockItem item, bool isLast) {
    final totalBag = item.warehouses.fold<double>(0, (sum, w) => sum + w.quantityBag);
    final totalMon = item.warehouses.fold<double>(0, (sum, w) => sum + w.quantityMon);
    final totalKg = item.warehouses.fold<double>(0, (sum, w) => sum + w.quantityKg);

    return ClipRRect(
      borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(16)) : BorderRadius.zero,
      child: Slidable(
        key: ValueKey(item.productName),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => StockDetailScreen(item: item)),
              ),
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              icon: Icons.visibility,
              label: 'View',
            ),
          ],
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text(item.productName, style: const TextStyle(fontWeight: FontWeight.w500))),
                Expanded(flex: 2, child: Text(totalBag.toStringAsFixed(2), textAlign: TextAlign.center)),
                Expanded(flex: 2, child: Text(totalMon.toStringAsFixed(2), textAlign: TextAlign.center)),
                Expanded(flex: 2, child: Text(totalKg.toStringAsFixed(2), textAlign: TextAlign.center)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
