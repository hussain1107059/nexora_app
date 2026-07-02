import 'package:flutter/material.dart';

import '../models/bank_transfer.dart';

class BankTransferFormScreen extends StatefulWidget {
  final BankTransfer? transfer;

  const BankTransferFormScreen({super.key, this.transfer});

  @override
  State<BankTransferFormScreen> createState() => _BankTransferFormScreenState();
}

class _BankTransferFormScreenState extends State<BankTransferFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountCtrl;
  late final TextEditingController _remarksCtrl;
  late String _sourceBank;
  late String _destinationBank;
  late DateTime _date;

  static const _banks = [
    'Sonali Bank Ltd',
    'Dutch Bangla Bank',
    'Islami Bank BD',
    'Agrani Bank',
    'Janata Bank',
  ];

  @override
  void initState() {
    super.initState();
    final t = widget.transfer;
    _amountCtrl = TextEditingController(text: t?.amount.toString() ?? '');
    _remarksCtrl = TextEditingController(text: t?.remarks ?? '');
    _sourceBank = t?.sourceBank ?? _banks.first;
    _destinationBank = t?.destinationBank ?? _banks.last;
    _date = t?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _remarksCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_sourceBank == _destinationBank) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Source and destination banks must be different')),
      );
      return;
    }
    final amount = double.tryParse(_amountCtrl.text) ?? 0;
    final transfer = BankTransfer(
      date: _date,
      sourceBank: _sourceBank,
      destinationBank: _destinationBank,
      amount: amount,
      remarks: _remarksCtrl.text.trim(),
    );
    Navigator.pop(context, transfer);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transfer != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Bank Transfer' : 'Add Bank Transfer'),
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
              _buildDateField(),
              const SizedBox(height: 14),
              _buildDropdown('From Bank', _sourceBank, _banks, (v) {
                if (v != null) setState(() => _sourceBank = v);
              }),
              const SizedBox(height: 14),
              _buildField('Amount', _amountCtrl, keyboardType: TextInputType.number, required: true),
              const SizedBox(height: 14),
              _buildDropdown('Destination Bank', _destinationBank, _banks.where((b) => b != _sourceBank).toList(), (v) {
                if (v != null) setState(() => _destinationBank = v);
              }),
              const SizedBox(height: 14),
              _buildField('Remarks', _remarksCtrl, maxLines: 3),
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

  Widget _buildDateField() {
    return InkWell(
      onTap: _pickDate,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${_date.day.toString().padLeft(2, '0')}/${_date.month.toString().padLeft(2, '0')}/${_date.year}'),
            const Icon(Icons.calendar_today, size: 18, color: Color(0xFF64748B)),
          ],
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

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
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
