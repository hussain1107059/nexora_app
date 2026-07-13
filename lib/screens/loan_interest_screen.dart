import 'package:flutter/material.dart';

import '../models/loan_interest.dart';

class LoanInterestScreen extends StatefulWidget {
  final List<LoanAccount> accounts;

  const LoanInterestScreen({super.key, required this.accounts});

  @override
  State<LoanInterestScreen> createState() => _LoanInterestScreenState();
}

class _LoanInterestScreenState extends State<LoanInterestScreen> {
  String? _selectedBank;
  String? _selectedLoanNo;

  List<String> get _banks => widget.accounts.map((a) => a.bank).toSet().toList();

  List<String> get _loanNos =>
      widget.accounts.where((a) => a.bank == _selectedBank).map((a) => a.loanNo).toList();

  List<LoanEntry> get _entries {
    if (_selectedBank == null || _selectedLoanNo == null) return [];
    final account = widget.accounts.firstWhere(
      (a) => a.bank == _selectedBank && a.loanNo == _selectedLoanNo,
      orElse: () => const LoanAccount(loanNo: '', bank: '', entries: []),
    );
    return account.entries;
  }

  @override
  void initState() {
    super.initState();
    if (widget.accounts.isNotEmpty) {
      _selectedBank = _banks.first;
      _selectedLoanNo = _loanNos.isNotEmpty ? _loanNos.first : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Loan Interest'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildDropdowns(),
          const SizedBox(height: 16),
          Expanded(child: _buildTable()),
        ],
      ),
    );
  }

  Widget _buildDropdowns() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _dropdown('Bank', _banks, _selectedBank, (v) {
            setState(() {
              _selectedBank = v;
              _selectedLoanNo = _loanNos.isNotEmpty ? _loanNos.first : null;
            });
          })),
          const SizedBox(width: 12),
          Expanded(child: _dropdown('Loan No.', _loanNos, _selectedLoanNo, (v) {
            setState(() => _selectedLoanNo = v);
          })),
        ],
      ),
    );
  }

  Widget _dropdown(String label, List<String> items, String? value, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(label, style: const TextStyle(color: Color(0xFF64748B))),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTable() {
    final entries = _entries;
    if (entries.isEmpty) {
      return const Center(child: Text('No data available', style: TextStyle(color: Colors.black54)));
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      itemCount: entries.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) return _buildHeader();
        final entry = entries[i - 1];
        final isLast = i == entries.length;
        return _buildRow(entry, isLast);
      },
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
          Expanded(flex: 2, child: Text('Allocation', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)), textAlign: TextAlign.right)),
          Expanded(flex: 2, child: Text('Repayment', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)), textAlign: TextAlign.right)),
          Expanded(flex: 2, child: Text('Balance', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)), textAlign: TextAlign.right)),
          Expanded(flex: 2, child: Text('Interest', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)), textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Widget _buildRow(LoanEntry entry, bool isLast) {
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
            Expanded(flex: 2, child: Text(entry.date, style: const TextStyle(fontWeight: FontWeight.w500))),
            Expanded(flex: 2, child: Text(entry.allocation.toStringAsFixed(2), textAlign: TextAlign.right)),
            Expanded(flex: 2, child: Text(entry.repayment.toStringAsFixed(2), textAlign: TextAlign.right)),
            Expanded(flex: 2, child: Text(entry.balance.toStringAsFixed(2), textAlign: TextAlign.right)),
            Expanded(flex: 2, child: Text(entry.interest.toStringAsFixed(2), textAlign: TextAlign.right)),
          ],
        ),
      ),
    );
  }
}
