import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/bank.dart';
import 'bank_detail_screen.dart';
import 'bank_form_screen.dart';

class BankScreen extends StatefulWidget {
  const BankScreen({super.key});

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  final List<Bank> _banks = [
    const Bank(
      accountName: 'Sonali Bank Ltd',
      initialBalance: 150000,
      accountNumber: 'STB-123456789',
      branchName: 'Motijheel',
      accountType: 'Current',
      routingNumber: 'SNLBDH123',
      description: 'Main business account',
    ),
    const Bank(
      accountName: 'Dutch Bangla Bank',
      initialBalance: 85000,
      accountNumber: 'DBB-987654321',
      branchName: 'Gulshan',
      accountType: 'Savings',
      routingNumber: 'DBBLDH456',
      description: 'Salary account',
    ),
    const Bank(
      accountName: 'Islami Bank BD',
      initialBalance: 220000,
      accountNumber: 'IBB-456789123',
      branchName: 'Banani',
      accountType: 'Fixed Deposit',
      routingNumber: 'IBBLDH789',
      description: 'Fixed deposit account',
    ),
  ];

  void _openForm([Bank? bank]) async {
    final result = await Navigator.push<Bank>(
      context,
      MaterialPageRoute(builder: (_) => BankFormScreen(bank: bank)),
    );
    if (result != null && mounted) {
      setState(() {
        if (bank != null) {
          final idx = _banks.indexOf(bank);
          _banks[idx] = result;
        } else {
          _banks.add(result);
        }
      });
    }
  }

  void _viewBank(Bank bank) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BankDetailScreen(bank: bank)),
    );
  }

  void _delete(Bank bank) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Bank'),
        content: Text('Delete "${bank.accountName}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() => _banks.remove(bank));
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Bank'),
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
      body: _banks.isEmpty
          ? const Center(child: Text('No banks added yet', style: TextStyle(color: Colors.black54)))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
              itemCount: _banks.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) return _buildHeader();
                final bank = _banks[i - 1];
                final isLast = i == _banks.length;
                return _buildSlidableRow(bank, isLast);
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
          Expanded(flex: 2, child: Text('Bank Name', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 1, child: Text('Branch', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
        ],
      ),
    );
  }

  Widget _buildSlidableRow(Bank bank, bool isLast) {
    return ClipRRect(
      borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(16)) : BorderRadius.zero,
      child: Slidable(
        key: ValueKey(bank.accountNumber),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _viewBank(bank),
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
              onPressed: (_) => _openForm(bank),
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (_) => _delete(bank),
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
                Expanded(flex: 2, child: Text(bank.accountName)),
                Expanded(flex: 1, child: Text(bank.branchName)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
