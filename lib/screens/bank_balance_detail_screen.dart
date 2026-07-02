import 'package:flutter/material.dart';

import '../models/bank_balance.dart';

class BankBalanceDetailScreen extends StatelessWidget {
  final BankBalance bankBalance;

  const BankBalanceDetailScreen({super.key, required this.bankBalance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(bankBalance.bankName),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF2563EB)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Current Balance', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 4),
                Text('\$${bankBalance.balance.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              itemCount: bankBalance.statements.length,
              itemBuilder: (context, i) {
                final stmt = bankBalance.statements[i];
                final isLast = i == bankBalance.statements.length - 1;
                return _buildStatementRow(stmt, isLast);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: const Row(
        children: [
          Expanded(flex: 2, child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A), fontSize: 12))),
          Expanded(flex: 2, child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A), fontSize: 12))),
          Expanded(flex: 1, child: Text('Debit', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A), fontSize: 12))),
          Expanded(flex: 1, child: Text('Credit', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A), fontSize: 12))),
          Expanded(flex: 1, child: Text('Balance', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A), fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildStatementRow(StatementEntry stmt, bool isLast) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
        borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(16)) : BorderRadius.zero,
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('${stmt.date.day.toString().padLeft(2, '0')}/${stmt.date.month.toString().padLeft(2, '0')}/${stmt.date.year}', style: const TextStyle(fontSize: 12))),
          Expanded(flex: 2, child: Text(stmt.name, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
          Expanded(flex: 1, child: Text(stmt.debit > 0 ? '\$${stmt.debit.toStringAsFixed(0)}' : '', style: const TextStyle(fontSize: 12, color: Colors.red))),
          Expanded(flex: 1, child: Text(stmt.credit > 0 ? '\$${stmt.credit.toStringAsFixed(0)}' : '', style: const TextStyle(fontSize: 12, color: Colors.green))),
          Expanded(flex: 1, child: Text('\$${stmt.balance.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
