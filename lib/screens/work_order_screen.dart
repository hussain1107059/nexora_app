import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/work_order.dart';
import 'work_order_detail_screen.dart';
import 'work_order_form_screen.dart';

class WorkOrderScreen extends StatefulWidget {
  const WorkOrderScreen({super.key});

  @override
  State<WorkOrderScreen> createState() => _WorkOrderScreenState();
}

class _WorkOrderScreenState extends State<WorkOrderScreen> {
  final List<WorkOrder> _orders = [
    WorkOrder(
      date: DateTime(2026, 7, 10),
      workType: 'Whole Sale',
      organization: 'Green Agro',
      remarks: 'Bulk rice processing',
      items: [
        const WorkOrderItem(productName: 'Rice BR-28', quantity: 100),
        const WorkOrderItem(productName: 'Wheat', quantity: 50),
      ],
    ),
    WorkOrder(
      date: DateTime(2026, 7, 15),
      workType: 'Retail',
      organization: 'Rahim Store',
      remarks: 'Mixed order',
      items: [
        const WorkOrderItem(productName: 'Maize', quantity: 30),
      ],
    ),
  ];

  void _openForm([WorkOrder? order]) async {
    final result = await Navigator.push<WorkOrder>(
      context,
      MaterialPageRoute(builder: (_) => WorkOrderFormScreen(order: order)),
    );
    if (result != null && mounted) {
      setState(() {
        if (order != null) {
          final idx = _orders.indexOf(order);
          _orders[idx] = result;
        } else {
          _orders.add(result);
        }
      });
    }
  }

  void _view(WorkOrder order) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => WorkOrderDetailScreen(order: order)),
    );
  }

  void _delete(WorkOrder order) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Work Order'),
        content: Text('Delete work order for "${order.organization}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() => _orders.remove(order));
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
        title: const Text('Work Order'),
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
      body: _orders.isEmpty
          ? const Center(child: Text('No work orders added yet', style: TextStyle(color: Colors.black54)))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
              itemCount: _orders.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) return _buildHeader();
                final order = _orders[i - 1];
                final isLast = i == _orders.length;
                return _buildSlidableRow(order, isLast);
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
          Expanded(flex: 3, child: Text('Products', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 2, child: Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
        ],
      ),
    );
  }

  Widget _buildSlidableRow(WorkOrder order, bool isLast) {
    return ClipRRect(
      borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(16)) : BorderRadius.zero,
      child: Slidable(
        key: ValueKey('${order.date}_${order.organization}'),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _view(order),
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              icon: Icons.visibility,
              label: 'View',
            ),
            SlidableAction(
              onPressed: (_) => _view(order),
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              icon: Icons.shopping_cart_outlined,
              label: 'Sale',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _openForm(order),
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (_) => _delete(order),
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
                Expanded(flex: 2, child: Text(_formatDate(order.date), style: const TextStyle(fontSize: 12))),
                Expanded(flex: 3, child: Text(order.organization, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: order.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(item.productName, style: const TextStyle(fontSize: 12)),
                    )).toList(),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: order.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(item.quantity.toStringAsFixed(0), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
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
