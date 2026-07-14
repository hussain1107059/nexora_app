import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/inventory_loss.dart';
import 'inventory_loss_detail_screen.dart';
import 'inventory_loss_form_screen.dart';

class InventoryLossScreen extends StatefulWidget {
  const InventoryLossScreen({super.key});

  @override
  State<InventoryLossScreen> createState() => _InventoryLossScreenState();
}

class _InventoryLossScreenState extends State<InventoryLossScreen> {
  List<InventoryLoss> _data = [
    InventoryLoss(
      date: DateTime(2026, 7, 10),
      reason: 'Spoilage during transport',
      items: [
        const InventoryLossItem(productName: 'Rice BR-28', warehouse: 'Main Warehouse', quantity: 50, unitPrice: 45),
        const InventoryLossItem(productName: 'Wheat', warehouse: 'Main Warehouse', quantity: 30, unitPrice: 38),
      ],
    ),
    InventoryLoss(
      date: DateTime(2026, 7, 12),
      reason: 'Storage damage',
      items: [
        const InventoryLossItem(productName: 'Maize', warehouse: 'North Storage', quantity: 20, unitPrice: 42),
      ],
    ),
  ];

  void _openForm([InventoryLoss? loss]) {
    Navigator.push<InventoryLoss>(
      context,
      MaterialPageRoute(builder: (_) => InventoryLossFormScreen(loss: loss)),
    ).then((result) {
      if (result != null) {
        setState(() {
          if (loss != null) {
            final index = _data.indexOf(loss);
            if (index >= 0) _data[index] = result;
          } else {
            _data.insert(0, result);
          }
        });
      }
    });
  }

  void _view(InventoryLoss loss) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => InventoryLossDetailScreen(loss: loss)),
    );
  }

  void _delete(InventoryLoss loss) {
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
              setState(() => _data.remove(loss));
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
        title: const Text('Inventory Loss'),
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
          final loss = _data[index - 1];
          return _buildSlidableRow(loss, index == _data.length);
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
          Expanded(flex: 3, child: Text('Product Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
          Expanded(flex: 2, child: Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
          Expanded(flex: 2, child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
        ],
      ),
    );
  }

  Widget _buildSlidableRow(InventoryLoss loss, bool isLast) {
    return ClipRRect(
      borderRadius: isLast ? BorderRadius.circular(10) : BorderRadius.zero,
      child: Slidable(
        key: ValueKey(loss.hashCode),
        startActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _view(loss),
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
              onPressed: (_) => _openForm(loss),
              backgroundColor: const Color(0xFFD97706),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (_) => _delete(loss),
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
            onTap: () => _openForm(loss),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                children: [
                  Expanded(flex: 2, child: Text(_formatDate(loss.date), style: const TextStyle(fontSize: 12))),
                  Expanded(flex: 3, child: Text(loss.items.map((e) => e.productName).join(', '), style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
                  Expanded(flex: 2, child: Text(loss.items.fold(0.0, (s, i) => s + i.quantity).toStringAsFixed(0), style: const TextStyle(fontSize: 12))),
                  Expanded(flex: 2, child: Text('\$${loss.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
