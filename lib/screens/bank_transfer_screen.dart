import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/bank_transfer.dart';
import 'bank_transfer_detail_screen.dart';
import 'bank_transfer_form_screen.dart';

class BankTransferScreen extends StatefulWidget {
  const BankTransferScreen({super.key});

  @override
  State<BankTransferScreen> createState() => _BankTransferScreenState();
}

class _BankTransferScreenState extends State<BankTransferScreen> {
  final List<BankTransfer> _transfers = [
    BankTransfer(
      date: DateTime(2026, 6, 15),
      sourceBank: 'Sonali Bank Ltd',
      destinationBank: 'Dutch Bangla Bank',
      amount: 50000,
      remarks: 'Monthly fund transfer',
    ),
    BankTransfer(
      date: DateTime(2026, 6, 20),
      sourceBank: 'Dutch Bangla Bank',
      destinationBank: 'Islami Bank BD',
      amount: 25000,
      remarks: 'Project payment',
    ),
    BankTransfer(
      date: DateTime(2026, 6, 25),
      sourceBank: 'Islami Bank BD',
      destinationBank: 'Sonali Bank Ltd',
      amount: 100000,
      remarks: 'Investment return',
    ),
  ];

  void _openForm([BankTransfer? transfer]) async {
    final result = await Navigator.push<BankTransfer>(
      context,
      MaterialPageRoute(builder: (_) => BankTransferFormScreen(transfer: transfer)),
    );
    if (result != null && mounted) {
      setState(() {
        if (transfer != null) {
          final idx = _transfers.indexOf(transfer);
          _transfers[idx] = result;
        } else {
          _transfers.add(result);
        }
      });
    }
  }

  void _viewTransfer(BankTransfer transfer) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BankTransferDetailScreen(transfer: transfer)),
    );
  }

  void _delete(BankTransfer transfer) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Transfer'),
        content: Text('Delete transfer of \$${transfer.amount.toStringAsFixed(2)}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() => _transfers.remove(transfer));
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
        title: const Text('Bank Transfer'),
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
      body: _transfers.isEmpty
          ? const Center(child: Text('No transfers added yet', style: TextStyle(color: Colors.black54)))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
              itemCount: _transfers.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) return _buildHeader();
                final transfer = _transfers[i - 1];
                final isLast = i == _transfers.length;
                return _buildSlidableRow(transfer, isLast);
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
          Expanded(flex: 2, child: Text('Source', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 2, child: Text('Destination', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 1, child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A))),),
        ],
      ),
    );
  }

  Widget _buildSlidableRow(BankTransfer transfer, bool isLast) {
    return ClipRRect(
      borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(16)) : BorderRadius.zero,
      child: Slidable(
        key: ValueKey('${transfer.date}_${transfer.sourceBank}_${transfer.destinationBank}'),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _viewTransfer(transfer),
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
              onPressed: (_) => _openForm(transfer),
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (_) => _delete(transfer),
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
                Expanded(flex: 2, child: Text(_formatDate(transfer.date))),
                Expanded(flex: 2, child: Text(transfer.sourceBank, overflow: TextOverflow.ellipsis)),
                Expanded(flex: 2, child: Text(transfer.destinationBank, overflow: TextOverflow.ellipsis)),
                Expanded(flex: 1, child: Text('\$${transfer.amount.toStringAsFixed(0)}')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
