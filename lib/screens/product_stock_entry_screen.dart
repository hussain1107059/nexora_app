import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/product_stock_entry.dart';
import 'product_stock_entry_detail_screen.dart';
import 'product_stock_entry_form_screen.dart';

class ProductStockEntryScreen extends StatefulWidget {
  const ProductStockEntryScreen({super.key});

  @override
  State<ProductStockEntryScreen> createState() => _ProductStockEntryScreenState();
}

class _ProductStockEntryScreenState extends State<ProductStockEntryScreen> {
  final List<ProductStockEntry> _entries = [
    ProductStockEntry(
      date: DateTime(2026, 7, 13),
      productionChalan: 'CH-001',
      manufactureCost: 5000,
      generalCost: 2000,
      remarks: 'Rice production batch',
      items: const [
        StockEntryItem(productCategory: 'Rice', productQuantity: 500, productCosting: 25000, warehouse: 'Main Warehouse'),
      ],
    ),
    ProductStockEntry(
      date: DateTime(2026, 7, 15),
      productionChalan: 'CH-002',
      manufactureCost: 3000,
      generalCost: 1500,
      remarks: 'Flour milling',
      items: const [
        StockEntryItem(productCategory: 'Flour', productQuantity: 300, productCosting: 18000, warehouse: 'North Storage'),
      ],
    ),
    ProductStockEntry(
      date: DateTime(2026, 7, 17),
      productionChalan: 'CH-003',
      manufactureCost: 4000,
      generalCost: 1000,
      remarks: 'Mixed grains',
      items: const [
        StockEntryItem(productCategory: 'Maize', productQuantity: 50, productCosting: 3000, warehouse: 'East Storage'),
        StockEntryItem(productCategory: 'Wheat', productQuantity: 100, productCosting: 6000, warehouse: 'East Storage'),
      ],
    ),
  ];

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _openForm([ProductStockEntry? entry]) async {
    final result = await Navigator.push<ProductStockEntry>(
      context,
      MaterialPageRoute(builder: (_) => ProductStockEntryFormScreen(entry: entry)),
    );
    if (result != null && mounted) {
      setState(() {
        if (entry != null) {
          final idx = _entries.indexOf(entry);
          _entries[idx] = result;
        } else {
          _entries.add(result);
        }
      });
    }
  }

  void _view(ProductStockEntry entry) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductStockEntryDetailScreen(entry: entry)),
    );
  }

  void _delete(ProductStockEntry entry) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Stock Entry'),
        content: Text('Delete stock entry for Chalan "${entry.productionChalan}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() => _entries.remove(entry));
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Product Stock Entry'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _entries.isEmpty
          ? const Center(child: Text('No stock entries added yet', style: TextStyle(color: Colors.black54)))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
              itemCount: _entries.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) return _buildHeader();
                final entry = _entries[i - 1];
                final isLast = i == _entries.length;
                return _buildSlidableRow(entry, isLast);
              },
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: const Row(
        children: [
          Expanded(flex: 2, child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 3, child: Text('Chalan', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 3, child: Text('Category', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 2, child: Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
        ],
      ),
    );
  }

  Widget _buildSlidableRow(ProductStockEntry entry, bool isLast) {
    return ClipRRect(
      borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(16)) : BorderRadius.zero,
      child: Slidable(
        key: ValueKey(entry.productionChalan),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _view(entry),
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              icon: Icons.visibility,
              label: 'View',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _openForm(entry),
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (_) => _delete(entry),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: Text(_formatDate(entry.date), style: const TextStyle(fontSize: 12))),
                Expanded(flex: 3, child: Text(entry.productionChalan, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: entry.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(item.productCategory, style: const TextStyle(fontSize: 12)),
                    )).toList(),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: entry.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(item.productQuantity.toStringAsFixed(0), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    )).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
