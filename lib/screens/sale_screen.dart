import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/sale.dart';
import 'sale_detail_screen.dart';
import 'sale_form_screen.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key});

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  final List<Sale> _sales = [
    Sale(
      date: DateTime(2026, 7, 10),
      saleType: 'Whole Sale',
      customer: 'Green Agro',
      chalanNo: 'CH-001',
      partyNo: 'PT-101',
      serialNo: 'SR-001',
      truck: 'Truck A (DA-1234)',
      remarks: 'Bulk rice order',
      items: [
        const SaleItem(productName: 'Rice BR-28', saleRate: 55, warehouse: 'Main Warehouse', packageWeight: 50, quantity: 100),
      ],
    ),
    Sale(
      date: DateTime(2026, 7, 15),
      saleType: 'Retail',
      customer: 'Rahim Store',
      chalanNo: 'CH-002',
      partyNo: 'PT-102',
      serialNo: 'SR-002',
      truck: 'Truck B (DA-5678)',
      remarks: 'Mixed items',
      items: [
        const SaleItem(productName: 'Wheat', saleRate: 40, warehouse: 'Main Warehouse', packageWeight: 50, quantity: 50),
        const SaleItem(productName: 'Maize', saleRate: 35, warehouse: 'North Storage', packageWeight: 25, quantity: 30),
      ],
    ),
  ];

  void _openForm([Sale? sale]) async {
    final result = await Navigator.push<Sale>(
      context,
      MaterialPageRoute(builder: (_) => SaleFormScreen(sale: sale)),
    );
    if (result != null && mounted) {
      setState(() {
        if (sale != null) {
          final idx = _sales.indexOf(sale);
          _sales[idx] = result;
        } else {
          _sales.add(result);
        }
      });
    }
  }

  void _viewSale(Sale sale) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SaleDetailScreen(sale: sale)),
    );
  }

  void _delete(Sale sale) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Sale'),
        content: Text('Delete sale to "${sale.customer}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() => _sales.remove(sale));
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
        title: const Text('Sale'),
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
      body: _sales.isEmpty
          ? const Center(child: Text('No sale added yet', style: TextStyle(color: Colors.black54)))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
              itemCount: _sales.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) return _buildHeader();
                final sale = _sales[i - 1];
                final isLast = i == _sales.length;
                return _buildSlidableRow(sale, isLast);
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
          Expanded(flex: 2, child: Text('Invoice', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 3, child: Text('Organization', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 2, child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
        ],
      ),
    );
  }

  Widget _buildSlidableRow(Sale sale, bool isLast) {
    final invoiceNo = 'INV-${sale.date.year}${sale.date.month.toString().padLeft(2, '0')}${sale.date.day.toString().padLeft(2, '0')}-${sale.serialNo}';
    return ClipRRect(
      borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(16)) : BorderRadius.zero,
      child: Slidable(
        key: ValueKey('${sale.date}_${sale.customer}_${sale.serialNo}'),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _viewSale(sale),
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
              onPressed: (_) => _openForm(sale),
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (_) => _delete(sale),
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
                Expanded(flex: 2, child: Text(_formatDate(sale.date), style: const TextStyle(fontSize: 12))),
                Expanded(flex: 2, child: Text(invoiceNo, style: const TextStyle(fontSize: 12))),
                Expanded(flex: 3, child: Text(sale.customer, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
                Expanded(flex: 2, child: Text('\$${sale.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
