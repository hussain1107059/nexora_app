import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/expenditure.dart';
import 'expenditure_detail_screen.dart';
import 'expenditure_form_screen.dart';

class ExpenditureScreen extends StatefulWidget {
  const ExpenditureScreen({super.key});

  @override
  State<ExpenditureScreen> createState() => _ExpenditureScreenState();
}

class _ExpenditureScreenState extends State<ExpenditureScreen> {
  final List<Expenditure> _expenditures = [
    Expenditure(
      date: DateTime(2026, 7, 5),
      type: 'Feed',
      paymentType: 'Cash',
      sellerName: 'Feed Supplier A',
      description: 'Starter feed purchase',
      items: [
        const ExpenditureItem(itemName: 'Starter Feed', saleRate: 2500, quantity: 6),
      ],
    ),
    Expenditure(
      date: DateTime(2026, 7, 12),
      type: 'Medicine',
      paymentType: 'Bank',
      bankName: 'Sonali Bank Ltd',
      sellerName: 'Vet Supply Co.',
      description: 'Vaccine for layer chicks',
      items: [
        const ExpenditureItem(itemName: 'Vaccine A', saleRate: 1200, quantity: 5),
        const ExpenditureItem(itemName: 'Syringe', saleRate: 50, quantity: 10),
      ],
    ),
    Expenditure(
      date: DateTime(2026, 7, 22),
      type: 'Equipment',
      paymentType: 'Cash',
      sellerName: 'Farm Equipment Ltd.',
      description: 'Incubator parts and tools',
      items: [
        const ExpenditureItem(itemName: 'Thermostat', saleRate: 3500, quantity: 2),
        const ExpenditureItem(itemName: 'Heater Element', saleRate: 1200, quantity: 4),
      ],
    ),
  ];

  void _openForm([Expenditure? expenditure]) async {
    final result = await Navigator.push<Expenditure>(
      context,
      MaterialPageRoute(builder: (_) => ExpenditureFormScreen(expenditure: expenditure)),
    );
    if (result != null && mounted) {
      setState(() {
        if (expenditure != null) {
          final idx = _expenditures.indexOf(expenditure);
          _expenditures[idx] = result;
        } else {
          _expenditures.add(result);
        }
      });
    }
  }

  void _viewExpenditure(Expenditure expenditure) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ExpenditureDetailScreen(expenditure: expenditure)),
    );
  }

  void _delete(Expenditure expenditure) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Expenditure'),
        content: Text('Delete expenditure from "${expenditure.sellerName}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() => _expenditures.remove(expenditure));
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
        title: const Text('Expenditure'),
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
      body: _expenditures.isEmpty
          ? const Center(child: Text('No expenditure added yet', style: TextStyle(color: Colors.black54)))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
              itemCount: _expenditures.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) return _buildHeader();
                final expenditure = _expenditures[i - 1];
                final isLast = i == _expenditures.length;
                return _buildSlidableRow(expenditure, isLast);
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
          Expanded(flex: 2, child: Text('Type', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 2, child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 3, child: Text('Description', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
        ],
      ),
    );
  }

  Widget _buildSlidableRow(Expenditure expenditure, bool isLast) {
    return ClipRRect(
      borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(16)) : BorderRadius.zero,
      child: Slidable(
        key: ValueKey('${expenditure.date}_${expenditure.sellerName}'),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _viewExpenditure(expenditure),
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
              onPressed: (_) => _openForm(expenditure),
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (_) => _delete(expenditure),
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
                Expanded(flex: 2, child: Text(_formatDate(expenditure.date), style: const TextStyle(fontSize: 12))),
                Expanded(flex: 2, child: Text(expenditure.type, style: const TextStyle(fontSize: 12))),
                Expanded(flex: 2, child: Text('\$${expenditure.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12))),
                Expanded(
                  flex: 3,
                  child: Text(
                    expenditure.description,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
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
