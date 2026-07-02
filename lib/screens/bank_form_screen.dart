import 'package:flutter/material.dart';

import '../models/bank.dart';

class BankFormScreen extends StatefulWidget {
  final Bank? bank;

  const BankFormScreen({super.key, this.bank});

  @override
  State<BankFormScreen> createState() => _BankFormScreenState();
}

class _BankFormScreenState extends State<BankFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _accountNameCtrl;
  late final TextEditingController _initialBalanceCtrl;
  late final TextEditingController _accountNumberCtrl;
  late final TextEditingController _branchNameCtrl;
  late final TextEditingController _routingNumberCtrl;
  late final TextEditingController _descriptionCtrl;
  String _accountType = 'Savings';

  static const _types = ['Savings', 'Current', 'Fixed Deposit', 'Loan', 'Salary'];

  @override
  void initState() {
    super.initState();
    final b = widget.bank;
    _accountNameCtrl = TextEditingController(text: b?.accountName ?? '');
    _initialBalanceCtrl = TextEditingController(text: b?.initialBalance.toString() ?? '');
    _accountNumberCtrl = TextEditingController(text: b?.accountNumber ?? '');
    _branchNameCtrl = TextEditingController(text: b?.branchName ?? '');
    _routingNumberCtrl = TextEditingController(text: b?.routingNumber ?? '');
    _descriptionCtrl = TextEditingController(text: b?.description ?? '');
    if (b != null) _accountType = b.accountType;
  }

  @override
  void dispose() {
    _accountNameCtrl.dispose();
    _initialBalanceCtrl.dispose();
    _accountNumberCtrl.dispose();
    _branchNameCtrl.dispose();
    _routingNumberCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final balance = double.tryParse(_initialBalanceCtrl.text) ?? 0;
    final bank = Bank(
      accountName: _accountNameCtrl.text.trim(),
      initialBalance: balance,
      accountNumber: _accountNumberCtrl.text.trim(),
      branchName: _branchNameCtrl.text.trim(),
      accountType: _accountType,
      routingNumber: _routingNumberCtrl.text.trim(),
      description: _descriptionCtrl.text.trim(),
    );
    Navigator.pop(context, bank);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.bank != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Bank' : 'Add Bank'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildField('Account Name', _accountNameCtrl, required: true),
              const SizedBox(height: 14),
              _buildField('Initial Balance', _initialBalanceCtrl, keyboardType: TextInputType.number, required: true),
              const SizedBox(height: 14),
              _buildField('Account Number', _accountNumberCtrl, required: true),
              const SizedBox(height: 14),
              _buildField('Branch Name', _branchNameCtrl, required: true),
              const SizedBox(height: 14),
              _buildDropdown('Account Type', _accountType, _types),
              const SizedBox(height: 14),
              _buildField('Routing Number', _routingNumberCtrl, required: true),
              const SizedBox(height: 14),
              _buildField('Description', _descriptionCtrl, maxLines: 3),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, {TextInputType? keyboardType, bool required = false, int maxLines = 1}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: required ? (v) => (v == null || v.trim().isEmpty) ? '$label is required' : null : null,
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (v) {
        if (v != null) setState(() => _accountType = v);
      },
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
