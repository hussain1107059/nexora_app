import 'package:flutter/material.dart';

import '../models/withdrawal.dart';

class WithdrawalFormScreen extends StatefulWidget {
  final Withdrawal? withdrawal;

  const WithdrawalFormScreen({super.key, this.withdrawal});

  @override
  State<WithdrawalFormScreen> createState() => _WithdrawalFormScreenState();
}

class _WithdrawalFormScreenState extends State<WithdrawalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _personCtrl;
  late final TextEditingController _amountCtrl;
  late final TextEditingController _reasonCtrl;
  late final TextEditingController _commentCtrl;
  late String _paymentType;
  late String? _bankName;
  late DateTime _date;

  static const _paymentTypes = ['Cash', 'Bank', 'Cheque', 'Mobile Banking'];
  static const _banks = ['Sonali Bank Ltd', 'Dutch Bangla Bank', 'Islami Bank BD', 'Agrani Bank', 'Janata Bank'];

  @override
  void initState() {
    super.initState();
    final w = widget.withdrawal;
    _personCtrl = TextEditingController(text: w?.person ?? '');
    _amountCtrl = TextEditingController(text: w?.amount.toString() ?? '');
    _reasonCtrl = TextEditingController(text: w?.reason ?? '');
    _commentCtrl = TextEditingController(text: w?.comment ?? '');
    _paymentType = w?.paymentType ?? _paymentTypes.first;
    _bankName = w?.bankName;
    _date = w?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _personCtrl.dispose();
    _amountCtrl.dispose();
    _reasonCtrl.dispose();
    _commentCtrl.dispose();
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
    if (_paymentType == 'Bank' && (_bankName == null || _bankName!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a bank name')),
      );
      return;
    }
    final amount = double.tryParse(_amountCtrl.text) ?? 0;
    final withdrawal = Withdrawal(
      person: _personCtrl.text.trim(),
      paymentType: _paymentType,
      bankName: _paymentType == 'Bank' ? _bankName : null,
      date: _date,
      amount: amount,
      reason: _reasonCtrl.text.trim(),
      comment: _commentCtrl.text.trim(),
    );
    Navigator.pop(context, withdrawal);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.withdrawal != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Withdrawal' : 'Add Withdrawal'),
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
              _buildField('Withdrawal Person', _personCtrl, required: true),
              const SizedBox(height: 14),
              _buildDropdown('Payment Type', _paymentType, _paymentTypes, (v) {
                if (v != null) setState(() => _paymentType = v);
              }),
              if (_paymentType == 'Bank') ...[
                const SizedBox(height: 14),
                _buildDropdown('Bank Name', _bankName ?? _banks.first, _banks, (v) {
                  if (v != null) setState(() => _bankName = v);
                }),
              ],
              const SizedBox(height: 14),
              _buildDateField(),
              const SizedBox(height: 14),
              _buildField('Amount', _amountCtrl, keyboardType: TextInputType.number, required: true),
              const SizedBox(height: 14),
              _buildField('Reason', _reasonCtrl),
              const SizedBox(height: 14),
              _buildField('Comment', _commentCtrl, maxLines: 3),
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
          labelText: 'Withdrawal Date',
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
