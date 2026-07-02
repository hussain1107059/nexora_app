import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/withdrawal.dart';
import 'withdrawal_detail_screen.dart';
import 'withdrawal_form_screen.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final List<Withdrawal> _withdrawals = [
    Withdrawal(
      person: 'Employee 1',
      paymentType: 'Cash',
      date: DateTime(2026, 6, 8),
      amount: 15000,
      reason: 'Travel advance',
      comment: 'Approved by manager',
    ),
    Withdrawal(
      person: 'Supplier X',
      paymentType: 'Bank',
      bankName: 'Sonali Bank Ltd',
      date: DateTime(2026, 6, 15),
      amount: 50000,
      reason: 'Material purchase',
      comment: 'Invoice #INV-123',
    ),
    Withdrawal(
      person: 'Office Rent',
      paymentType: 'Cheque',
      date: DateTime(2026, 6, 25),
      amount: 30000,
      reason: 'Monthly rent payment',
      comment: 'June 2026 rent',
    ),
  ];

  void _openForm([Withdrawal? withdrawal]) async {
    final result = await Navigator.push<Withdrawal>(
      context,
      MaterialPageRoute(builder: (_) => WithdrawalFormScreen(withdrawal: withdrawal)),
    );
    if (result != null && mounted) {
      setState(() {
        if (withdrawal != null) {
          final idx = _withdrawals.indexOf(withdrawal);
          _withdrawals[idx] = result;
        } else {
          _withdrawals.add(result);
        }
      });
    }
  }

  void _viewWithdrawal(Withdrawal withdrawal) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => WithdrawalDetailScreen(withdrawal: withdrawal)),
    );
  }

  void _delete(Withdrawal withdrawal) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Withdrawal'),
        content: Text('Delete withdrawal by "${withdrawal.person}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() => _withdrawals.remove(withdrawal));
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
        title: const Text('Withdrawal'),
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
      body: _withdrawals.isEmpty
          ? const Center(child: Text('No withdrawals added yet', style: TextStyle(color: Colors.black54)))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
              itemCount: _withdrawals.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) return _buildHeader();
                final withdrawal = _withdrawals[i - 1];
                final isLast = i == _withdrawals.length;
                return _buildSlidableRow(withdrawal, isLast);
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

  Widget _buildSlidableRow(Withdrawal withdrawal, bool isLast) {
    return ClipRRect(
      borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(16)) : BorderRadius.zero,
      child: Slidable(
        key: ValueKey('${withdrawal.date}_${withdrawal.person}'),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _viewWithdrawal(withdrawal),
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
              onPressed: (_) => _openForm(withdrawal),
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (_) => _delete(withdrawal),
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
                Expanded(flex: 2, child: Text(_formatDate(withdrawal.date), style: const TextStyle(fontSize: 12))),
                Expanded(flex: 2, child: Text(withdrawal.person, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
                Expanded(flex: 1, child: Text('\$${withdrawal.amount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
