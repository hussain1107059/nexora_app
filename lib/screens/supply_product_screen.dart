import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/supply_product.dart';
import 'supply_product_detail_screen.dart';
import 'supply_product_form_screen.dart';

class SupplyProductScreen extends StatefulWidget {
  const SupplyProductScreen({super.key});

  @override
  State<SupplyProductScreen> createState() => _SupplyProductScreenState();
}

class _SupplyProductScreenState extends State<SupplyProductScreen> {
  final List<SupplyProduct> _products = [
    SupplyProduct(
      chalanDate: DateTime(2026, 7, 10),
      chalanNo: 'CH-001',
      partyNo: 'PT-101',
      serialNo: 'SR-001',
      supplier: 'Sonali Suppliers',
      truckNumber: 'Truck A (DA-1234)',
      remarks: 'Fertilizer supply',
      items: [
        const SupplyProductItem(
          productName: 'DAP Fertilizer', buyRate: 55, numberOfBags: 100,
          quantityKg: 5000, weightPerBagMon: 50, warehouse: 'Main Warehouse',
        ),
      ],
    ),
    SupplyProduct(
      chalanDate: DateTime(2026, 7, 15),
      chalanNo: 'CH-002',
      partyNo: 'PT-102',
      serialNo: 'SR-002',
      supplier: 'Alim Store',
      truckNumber: 'Truck B (DA-5678)',
      remarks: 'Grain supply',
      items: [
        const SupplyProductItem(
          productName: 'Wheat', buyRate: 40, numberOfBags: 50,
          quantityKg: 2500, weightPerBagMon: 50, warehouse: 'North Storage',
        ),
        const SupplyProductItem(
          productName: 'Maize', buyRate: 35, numberOfBags: 30,
          quantityKg: 1500, weightPerBagMon: 50, warehouse: 'South Storage',
        ),
      ],
    ),
  ];

  void _openForm([SupplyProduct? product]) async {
    final result = await Navigator.push<SupplyProduct>(
      context,
      MaterialPageRoute(builder: (_) => SupplyProductFormScreen(product: product)),
    );
    if (result != null && mounted) {
      setState(() {
        if (product != null) {
          final idx = _products.indexOf(product);
          _products[idx] = result;
        } else {
          _products.add(result);
        }
      });
    }
  }

  void _view(SupplyProduct product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SupplyProductDetailScreen(product: product)),
    );
  }

  void _delete(SupplyProduct product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Supply'),
        content: Text('Delete supply from "${product.supplier}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() => _products.remove(product));
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
        title: const Text('Supply Product'),
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
      body: _products.isEmpty
          ? const Center(child: Text('No supply added yet', style: TextStyle(color: Colors.black54)))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
              itemCount: _products.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) return _buildHeader();
                final product = _products[i - 1];
                final isLast = i == _products.length;
                return _buildSlidableRow(product, isLast);
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
          Expanded(flex: 3, child: Text('Organization', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 2, child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 3, child: Text('Remarks', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
        ],
      ),
    );
  }

  Widget _buildSlidableRow(SupplyProduct product, bool isLast) {
    return ClipRRect(
      borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(16)) : BorderRadius.zero,
      child: Slidable(
        key: ValueKey('${product.chalanDate}_${product.supplier}'),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _view(product),
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
              onPressed: (_) => _openForm(product),
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (_) => _delete(product),
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
              children: [
                Expanded(flex: 2, child: Text(_formatDate(product.chalanDate), style: const TextStyle(fontSize: 12))),
                Expanded(flex: 3, child: Text(product.supplier, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
                Expanded(flex: 2, child: Text('\$${product.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12))),
                Expanded(flex: 3, child: Text(product.remarks, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
