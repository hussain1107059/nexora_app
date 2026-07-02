import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/hatchery_expenditure.dart';
import 'hatchery_expenditure_detail_screen.dart';
import 'hatchery_expenditure_form_screen.dart';

class HatcheryExpenditureScreen extends StatefulWidget {
  const HatcheryExpenditureScreen({super.key});

  @override
  State<HatcheryExpenditureScreen> createState() => _HatcheryExpenditureScreenState();
}

class _HatcheryExpenditureScreenState extends State<HatcheryExpenditureScreen> {
  final List<HatcheryExpenditure> _expenditures = [
    HatcheryExpenditure(
      expenditureType: 'Feed',
      date: DateTime(2026, 6, 5),
      vendorName: 'Feed Supplier A',
      vendorAddress: 'Dhaka',
      amount: 15000,
      remarks: 'Starter feed for batch #5',
    ),
    HatcheryExpenditure(
      expenditureType: 'Medicine',
      date: DateTime(2026, 6, 12),
      vendorName: 'Vet Supply Co.',
      vendorAddress: 'Gazipur',
      amount: 8500,
      remarks: 'Vaccine for layer chicks',
    ),
    HatcheryExpenditure(
      expenditureType: 'Equipment',
      date: DateTime(2026, 6, 22),
      vendorName: 'Farm Equipment Ltd.',
      vendorAddress: 'Savar',
      amount: 42000,
      remarks: 'New incubator parts',
    ),
  ];

  void _openForm([HatcheryExpenditure? expenditure]) async {
    final result = await Navigator.push<HatcheryExpenditure>(
      context,
      MaterialPageRoute(builder: (_) => HatcheryExpenditureFormScreen(expenditure: expenditure)),
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

  void _viewExpenditure(HatcheryExpenditure expenditure) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => HatcheryExpenditureDetailScreen(expenditure: expenditure)),
    );
  }

  void _delete(HatcheryExpenditure expenditure) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Expenditure'),
        content: Text('Delete expenditure to "${expenditure.vendorName}"?'),
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
        title: const Text('Hatchery Expenditure'),
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
          Expanded(flex: 2, child: Text('Vendor Name', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 1, child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A))),),
        ],
      ),
    );
  }

  Widget _buildSlidableRow(HatcheryExpenditure expenditure, bool isLast) {
    return ClipRRect(
      borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(16)) : BorderRadius.zero,
      child: Slidable(
        key: ValueKey('${expenditure.date}_${expenditure.vendorName}'),
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
                Expanded(flex: 2, child: Text(expenditure.vendorName, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
                Expanded(flex: 1, child: Text('\$${expenditure.amount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
