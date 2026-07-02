import 'package:flutter/material.dart';

import '../models/other_income.dart';

class OtherIncomeFormScreen extends StatefulWidget {
  final OtherIncome? income;

  const OtherIncomeFormScreen({super.key, this.income});

  @override
  State<OtherIncomeFormScreen> createState() => _OtherIncomeFormScreenState();
}

class _OtherIncomeFormScreenState extends State<OtherIncomeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _consumerNameCtrl;
  late final TextEditingController _amountCtrl;
  late final TextEditingController _remarksCtrl;
  late String _incomeSource;
  late String _paymentMethod;
  late String? _bankName;
  late DateTime _date;

  static const _incomeSources = ['Investment', 'Loan Interest', 'Sale', 'Commission', 'Dividend', 'Rent', 'Other'];
  static const _paymentMethods = ['Cash', 'Bank', 'Cheque', 'Mobile Banking'];
  static const _banks = ['Sonali Bank Ltd', 'Dutch Bangla Bank', 'Islami Bank BD', 'Agrani Bank', 'Janata Bank'];

  @override
  void initState() {
    super.initState();
    final i = widget.income;
    _consumerNameCtrl = TextEditingController(text: i?.consumerName ?? '');
    _amountCtrl = TextEditingController(text: i?.amount.toString() ?? '');
    _remarksCtrl = TextEditingController(text: i?.remarks ?? '');
    _incomeSource = i?.incomeSource ?? _incomeSources.first;
    _paymentMethod = i?.paymentMethod ?? _paymentMethods.first;
    _bankName = i?.bankName;
    _date = i?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _consumerNameCtrl.dispose();
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
    if (_paymentMethod == 'Bank' && (_bankName == null || _bankName!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a bank name')),
      );
      return;
    }
    final amount = double.tryParse(_amountCtrl.text) ?? 0;
    final income = OtherIncome(
      incomeSource: _incomeSource,
      consumerName: _consumerNameCtrl.text.trim(),
      date: _date,
      paymentMethod: _paymentMethod,
      bankName: _paymentMethod == 'Bank' ? _bankName : null,
      amount: amount,
      remarks: _remarksCtrl.text.trim(),
    );
    Navigator.pop(context, income);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.income != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Other Income' : 'Add Other Income'),
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
              _buildDropdown('Income Source', _incomeSource, _incomeSources, (v) {
                if (v != null) setState(() => _incomeSource = v);
              }),
              const SizedBox(height: 14),
              _buildField('Consumer Name', _consumerNameCtrl, required: true),
              const SizedBox(height: 14),
              _buildDateField(),
              const SizedBox(height: 14),
              _buildDropdown('Payment Method', _paymentMethod, _paymentMethods, (v) {
                if (v != null) setState(() => _paymentMethod = v);
              }),
              if (_paymentMethod == 'Bank') ...[
                const SizedBox(height: 14),
                _buildDropdown('Bank Name', _bankName ?? _banks.first, _banks, (v) {
                  if (v != null) setState(() => _bankName = v);
                }),
              ],
              const SizedBox(height: 14),
              _buildField('Amount', _amountCtrl, keyboardType: TextInputType.number, required: true),
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
          labelText: 'Income Date',
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
