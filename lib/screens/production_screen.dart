import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/production.dart';
import 'production_detail_screen.dart';
import 'production_form_screen.dart';

class ProductionScreen extends StatefulWidget {
  const ProductionScreen({super.key});

  @override
  State<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen> {
  final List<Production> _productions = [
    Production(
      date: DateTime(2026, 7, 12),
      chalanNo: 'CH-001',
      factory: 'Factory A',
      warehouse: 'Main Warehouse',
      remarks: 'Bulk rice production',
      items: const [
        ProductionItem(productName: 'Rice BR-28', numberOfBags: 500, productQuantity: 25000),
        ProductionItem(productName: 'Wheat', numberOfBags: 200, productQuantity: 10000),
      ],
    ),
    Production(
      date: DateTime(2026, 7, 14),
      chalanNo: 'CH-002',
      factory: 'Factory B',
      warehouse: 'North Storage',
      remarks: 'Flour milling',
      items: const [
        ProductionItem(productName: 'Wheat Flour', numberOfBags: 300, productQuantity: 15000),
      ],
    ),
    Production(
      date: DateTime(2026, 7, 16),
      chalanNo: 'CH-003',
      factory: 'Factory A',
      warehouse: 'East Storage',
      remarks: 'Mixed grains',
      items: const [
        ProductionItem(productName: 'Maize', numberOfBags: 150, productQuantity: 7500),
        ProductionItem(productName: 'Rice BR-28', numberOfBags: 100, productQuantity: 5000),
        ProductionItem(productName: 'Wheat', numberOfBags: 75, productQuantity: 3750),
      ],
    ),
  ];

  void _openForm([Production? production]) async {
    final result = await Navigator.push<Production>(
      context,
      MaterialPageRoute(builder: (_) => ProductionFormScreen(production: production)),
    );
    if (result != null && mounted) {
      setState(() {
        if (production != null) {
          final idx = _productions.indexOf(production);
          _productions[idx] = result;
        } else {
          _productions.add(result);
        }
      });
    }
  }

  void _view(Production production) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductionDetailScreen(production: production)),
    );
  }

  void _delete(Production production) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Production'),
        content: Text('Delete production for Chalan "${production.chalanNo}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() => _productions.remove(production));
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Production'),
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
      body: _productions.isEmpty
          ? const Center(child: Text('No production records added yet', style: TextStyle(color: Colors.black54)))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
              itemCount: _productions.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) return _buildHeader();
                final production = _productions[i - 1];
                final isLast = i == _productions.length;
                return _buildSlidableRow(production, isLast);
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
          Expanded(flex: 3, child: Text('Products', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 2, child: Text('Total Bag', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
        ],
      ),
    );
  }

  Widget _buildSlidableRow(Production production, bool isLast) {
    return ClipRRect(
      borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(16)) : BorderRadius.zero,
      child: Slidable(
        key: ValueKey(production.chalanNo),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _view(production),
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
              onPressed: (_) => _openForm(production),
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (_) => _delete(production),
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
                Expanded(flex: 2, child: Text(_formatDate(production.date), style: const TextStyle(fontSize: 12))),
                Expanded(flex: 3, child: Text(production.chalanNo, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: production.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(item.productName, style: const TextStyle(fontSize: 12)),
                    )).toList(),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: production.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(item.numberOfBags.toStringAsFixed(0), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
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
