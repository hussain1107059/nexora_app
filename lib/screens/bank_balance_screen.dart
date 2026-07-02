import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/bank_balance.dart';
import 'bank_balance_detail_screen.dart';

class BankBalanceScreen extends StatefulWidget {
  const BankBalanceScreen({super.key});

  @override
  State<BankBalanceScreen> createState() => _BankBalanceScreenState();
}

class _BankBalanceScreenState extends State<BankBalanceScreen> {
  final List<BankBalance> _bankBalances = [
    BankBalance(
      bankName: 'Sonali Bank Ltd',
      balance: 150000,
      statements: [
        StatementEntry(date: DateTime(2026, 6, 1), name: 'Opening Balance', debit: 0, credit: 200000, balance: 200000),
        StatementEntry(date: DateTime(2026, 6, 5), name: 'Payment Received', debit: 0, credit: 50000, balance: 250000),
        StatementEntry(date: DateTime(2026, 6, 10), name: 'Office Rent', debit: 30000, credit: 0, balance: 220000),
        StatementEntry(date: DateTime(2026, 6, 15), name: 'Transfer to DBBL', debit: 50000, credit: 0, balance: 170000),
        StatementEntry(date: DateTime(2026, 6, 20), name: 'Supplier Payment', debit: 20000, credit: 0, balance: 150000),
      ],
    ),
    BankBalance(
      bankName: 'Dutch Bangla Bank',
      balance: 85000,
      statements: [
        StatementEntry(date: DateTime(2026, 6, 1), name: 'Opening Balance', debit: 0, credit: 50000, balance: 50000),
        StatementEntry(date: DateTime(2026, 6, 10), name: 'Salary Credit', debit: 0, credit: 60000, balance: 110000),
        StatementEntry(date: DateTime(2026, 6, 15), name: 'Received from Sonali', debit: 0, credit: 50000, balance: 160000),
        StatementEntry(date: DateTime(2026, 6, 22), name: 'ATM Withdrawal', debit: 25000, credit: 0, balance: 135000),
        StatementEntry(date: DateTime(2026, 6, 28), name: 'Bill Payment', debit: 50000, credit: 0, balance: 85000),
      ],
    ),
    BankBalance(
      bankName: 'Islami Bank BD',
      balance: 220000,
      statements: [
        StatementEntry(date: DateTime(2026, 6, 1), name: 'Opening Balance', debit: 0, credit: 100000, balance: 100000),
        StatementEntry(date: DateTime(2026, 6, 8), name: 'Investment Return', debit: 0, credit: 150000, balance: 250000),
        StatementEntry(date: DateTime(2026, 6, 18), name: 'Project Expense', debit: 30000, credit: 0, balance: 220000),
      ],
    ),
  ];

  void _viewBankBalance(BankBalance bankBalance) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BankBalanceDetailScreen(bankBalance: bankBalance)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Bank Balance'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      body: _bankBalances.isEmpty
          ? const Center(child: Text('No bank balances added yet', style: TextStyle(color: Colors.black54)))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              itemCount: _bankBalances.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) return _buildHeader();
                final bankBalance = _bankBalances[i - 1];
                final isLast = i == _bankBalances.length;
                return _buildSlidableRow(bankBalance, isLast);
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
          Expanded(flex: 3, child: Text('Bank Name', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 2, child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A))),),
        ],
      ),
    );
  }

  Widget _buildSlidableRow(BankBalance bankBalance, bool isLast) {
    return ClipRRect(
      borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(16)) : BorderRadius.zero,
      child: Slidable(
        key: ValueKey(bankBalance.bankName),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _viewBankBalance(bankBalance),
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
              onPressed: (_) => _viewBankBalance(bankBalance),
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              icon: Icons.visibility,
              label: 'View',
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
                Expanded(flex: 3, child: Text(bankBalance.bankName)),
                Expanded(flex: 2, child: Text('\$${bankBalance.balance.toStringAsFixed(2)}')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
