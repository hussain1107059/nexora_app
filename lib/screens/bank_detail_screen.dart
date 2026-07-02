import 'package:flutter/material.dart';

import '../models/bank.dart';

class BankDetailScreen extends StatelessWidget {
  final Bank bank;

  const BankDetailScreen({super.key, required this.bank});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(bank.accountName),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          children: [
            _infoCard(context, 'Account Name', bank.accountName),
            const SizedBox(height: 12),
            _infoCard(context, 'Initial Balance', '\$${bank.initialBalance.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            _infoCard(context, 'Account Number', bank.accountNumber),
            const SizedBox(height: 12),
            _infoCard(context, 'Branch Name', bank.branchName),
            const SizedBox(height: 12),
            _infoCard(context, 'Account Type', bank.accountType),
            const SizedBox(height: 12),
            _infoCard(context, 'Routing Number', bank.routingNumber),
            if (bank.description.isNotEmpty) ...[
              const SizedBox(height: 12),
              _infoCard(context, 'Description', bank.description),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoCard(BuildContext context, String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF19243A))),
        ],
      ),
    );
  }
}
