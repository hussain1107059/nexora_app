import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/sale_return.dart';
import 'sale_return_detail_screen.dart';
import 'sale_return_form_screen.dart';

class SaleReturnScreen extends StatefulWidget {
  const SaleReturnScreen({super.key});

  @override
  State<SaleReturnScreen> createState() => _SaleReturnScreenState();
}

class _SaleReturnScreenState extends State<SaleReturnScreen> {
  List<SaleReturn> _data = [
    SaleReturn(
      date: DateTime(2026, 7, 18),
      invoiceNo: 'SR-001',
      organization: 'Green Agro',
      reason: 'Damaged goods',
      items: [
        const SaleReturnItem(productName: 'Rice BR-28', unitPrice: 55, quantity: 10, warehouse: 'Main Warehouse'),
      ],
    ),
    SaleReturn(
      date: DateTime(2026, 7, 20),
      invoiceNo: 'SR-002',
      organization: 'Rahim Store',
      reason: 'Quality issue',
      items: [
        const SaleReturnItem(productName: 'Wheat', unitPrice: 40, quantity: 5, warehouse: 'Main Warehouse'),
      ],
    ),
  ];

  void _openForm([SaleReturn? sr]) {
    Navigator.push<SaleReturn>(
      context,
      MaterialPageRoute(builder: (_) => SaleReturnFormScreen(saleReturn: sr)),
    ).then((result) {
      if (result != null) {
        setState(() {
          if (sr != null) {
            final index = _data.indexOf(sr);
            if (index >= 0) _data[index] = result;
          } else {
            _data.insert(0, result);
          }
        });
      }
    });
  }

  void _view(SaleReturn sr) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SaleReturnDetailScreen(saleReturn: sr)),
    );
  }

  void _delete(SaleReturn sr) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete'),
        content: const Text('Are you sure you want to delete this record?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _data.remove(sr));
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
        title: const Text('Sale Return'),
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
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
        itemCount: _data.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) return _buildHeader();
          final sr = _data[index - 1];
          return _buildSlidableRow(sr, index == _data.length);
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Expanded(flex: 2, child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
          Expanded(flex: 2, child: Text('Invoice', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
          Expanded(flex: 3, child: Text('Organization', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
          Expanded(flex: 2, child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
        ],
      ),
    );
  }

  Widget _buildSlidableRow(SaleReturn sr, bool isLast) {
    return ClipRRect(
      borderRadius: isLast ? BorderRadius.circular(10) : BorderRadius.zero,
      child: Slidable(
        key: ValueKey(sr.hashCode),
        startActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _view(sr),
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              icon: Icons.visibility,
              label: 'View',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _openForm(sr),
              backgroundColor: const Color(0xFFD97706),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (_) => _delete(sr),
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
          child: InkWell(
            onTap: () => _openForm(sr),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                children: [
                  Expanded(flex: 2, child: Text(_formatDate(sr.date), style: const TextStyle(fontSize: 12))),
                  Expanded(flex: 2, child: Text(sr.invoiceNo, style: const TextStyle(fontSize: 12))),
                  Expanded(flex: 3, child: Text(sr.organization, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
                  Expanded(flex: 2, child: Text('\$${sr.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
