import 'package:flutter/material.dart';

import '../models/organization.dart';

class OrganizationDetailScreen extends StatelessWidget {
  final String title;
  final Organization org;

  const OrganizationDetailScreen({super.key, required this.title, required this.org});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(org.name),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF2563EB)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(org.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Owner: ${org.owner}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                Text('Phone: ${org.phone}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 12),
                Text('Balance: ${org.balance.toStringAsFixed(2)} Tk', style: const TextStyle(color: Color(0xFF4ADE80), fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildHeader(),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              itemCount: org.transactions.length,
              itemBuilder: (context, i) {
                final t = org.transactions[i];
                final isLast = i == org.transactions.length - 1;
                return _buildRow(t, isLast);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: const Row(
        children: [
          Expanded(flex: 2, child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 2, child: Text('Type', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 2, child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)), textAlign: TextAlign.right)),
          Expanded(flex: 2, child: Text('Paid', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)), textAlign: TextAlign.right)),
          Expanded(flex: 2, child: Text('Due', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)), textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Widget _buildRow(OrgTransaction t, bool isLast) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(16)) : BorderRadius.zero,
        border: const Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        child: Row(
          children: [
            Expanded(flex: 2, child: Text(t.date, style: const TextStyle(fontWeight: FontWeight.w500))),
            Expanded(flex: 2, child: Text(t.type)),
            Expanded(flex: 2, child: Text(t.total.toStringAsFixed(2), textAlign: TextAlign.right)),
            Expanded(flex: 2, child: Text(t.paid.toStringAsFixed(2), textAlign: TextAlign.right, style: const TextStyle(color: Color(0xFF065F46)))),
            Expanded(flex: 2, child: Text(t.due.toStringAsFixed(2), textAlign: TextAlign.right, style: const TextStyle(color: Color(0xFF991B1B)))),
          ],
        ),
      ),
    );
  }
}
