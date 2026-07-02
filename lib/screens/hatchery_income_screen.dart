import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/hatchery_income.dart';
import 'hatchery_income_detail_screen.dart';
import 'hatchery_income_form_screen.dart';

class HatcheryIncomeScreen extends StatefulWidget {
  const HatcheryIncomeScreen({super.key});

  @override
  State<HatcheryIncomeScreen> createState() => _HatcheryIncomeScreenState();
}

class _HatcheryIncomeScreenState extends State<HatcheryIncomeScreen> {
  final List<HatcheryIncome> _incomes = [
    HatcheryIncome(
      date: DateTime(2026, 6, 5),
      buyerName: 'Farm A',
      buyerAddress: 'Dhaka',
      remarks: 'First batch',
      items: [
        HatcheryIncomeItem(type: 'Chick', productName: 'Broiler Chick', unitPrice: 50, quantity: 200),
        HatcheryIncomeItem(type: 'Feed', productName: 'Starter Feed', unitPrice: 500, quantity: 10),
      ],
    ),
    HatcheryIncome(
      date: DateTime(2026, 6, 12),
      buyerName: 'Client X',
      buyerAddress: 'Gazipur',
      remarks: '',
      items: [
        HatcheryIncomeItem(type: 'Egg', productName: 'Table Egg', unitPrice: 12, quantity: 500),
      ],
    ),
    HatcheryIncome(
      date: DateTime(2026, 6, 20),
      buyerName: 'Partner Y',
      buyerAddress: 'Savar',
      remarks: 'Weekly supply',
      items: [
        HatcheryIncomeItem(type: 'Chick', productName: 'Layer Chick', unitPrice: 65, quantity: 150),
        HatcheryIncomeItem(type: 'Medicine', productName: 'Vaccine', unitPrice: 200, quantity: 5),
        HatcheryIncomeItem(type: 'Feed', productName: 'Grower Feed', unitPrice: 480, quantity: 8),
      ],
    ),
  ];

  void _openForm([HatcheryIncome? income]) async {
    final result = await Navigator.push<HatcheryIncome>(
      context,
      MaterialPageRoute(builder: (_) => HatcheryIncomeFormScreen(income: income)),
    );
    if (result != null && mounted) {
      setState(() {
        if (income != null) {
          final idx = _incomes.indexOf(income);
          _incomes[idx] = result;
        } else {
          _incomes.add(result);
        }
      });
    }
  }

  void _viewIncome(HatcheryIncome income) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => HatcheryIncomeDetailScreen(income: income)),
    );
  }

  void _delete(HatcheryIncome income) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Income'),
        content: Text('Delete income from "${income.buyerName}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() => _incomes.remove(income));
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
        title: const Text('Hatchery Income'),
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
      body: _incomes.isEmpty
          ? const Center(child: Text('No income added yet', style: TextStyle(color: Colors.black54)))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
              itemCount: _incomes.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) return _buildHeader();
                final income = _incomes[i - 1];
                final isLast = i == _incomes.length;
                return _buildSlidableRow(income, isLast);
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
          Expanded(flex: 2, child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 1, child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A))),),
        ],
      ),
    );
  }

  Widget _buildSlidableRow(HatcheryIncome income, bool isLast) {
    return ClipRRect(
      borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(16)) : BorderRadius.zero,
      child: Slidable(
        key: ValueKey('${income.date}_${income.buyerName}'),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _viewIncome(income),
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
              onPressed: (_) => _openForm(income),
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (_) => _delete(income),
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
                Expanded(flex: 2, child: Text(_formatDate(income.date), style: const TextStyle(fontSize: 12))),
                Expanded(flex: 2, child: Text(income.buyerName, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
                Expanded(flex: 1, child: Text('\$${income.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
