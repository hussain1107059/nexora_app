import 'package:flutter/material.dart';

import '../models/hatchery_expenditure.dart';

class HatcheryExpenditureFormScreen extends StatefulWidget {
  final HatcheryExpenditure? expenditure;

  const HatcheryExpenditureFormScreen({super.key, this.expenditure});

  @override
  State<HatcheryExpenditureFormScreen> createState() => _HatcheryExpenditureFormScreenState();
}

class _HatcheryExpenditureFormScreenState extends State<HatcheryExpenditureFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _vendorNameCtrl;
  late final TextEditingController _vendorAddressCtrl;
  late final TextEditingController _amountCtrl;
  late final TextEditingController _remarksCtrl;
  late String _expenditureType;
  late DateTime _date;

  static const _expenditureTypes = ['Feed', 'Medicine', 'Equipment', 'Labour', 'Transport', 'Utilities', 'Other'];

  @override
  void initState() {
    super.initState();
    final e = widget.expenditure;
    _vendorNameCtrl = TextEditingController(text: e?.vendorName ?? '');
    _vendorAddressCtrl = TextEditingController(text: e?.vendorAddress ?? '');
    _amountCtrl = TextEditingController(text: e?.amount.toString() ?? '');
    _remarksCtrl = TextEditingController(text: e?.remarks ?? '');
    _expenditureType = e?.expenditureType ?? _expenditureTypes.first;
    _date = e?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _vendorNameCtrl.dispose();
    _vendorAddressCtrl.dispose();
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
    final amount = double.tryParse(_amountCtrl.text) ?? 0;
    final expenditure = HatcheryExpenditure(
      expenditureType: _expenditureType,
      date: _date,
      vendorName: _vendorNameCtrl.text.trim(),
      vendorAddress: _vendorAddressCtrl.text.trim(),
      amount: amount,
      remarks: _remarksCtrl.text.trim(),
    );
    Navigator.pop(context, expenditure);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.expenditure != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Expenditure' : 'Add Expenditure'),
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
              _buildDropdown('Expenditure Type', _expenditureType, _expenditureTypes, (v) {
                if (v != null) setState(() => _expenditureType = v);
              }),
              const SizedBox(height: 14),
              _buildDateField(),
              const SizedBox(height: 14),
              _buildField('Vendor Name', _vendorNameCtrl, required: true),
              const SizedBox(height: 14),
              _buildField('Vendor Address', _vendorAddressCtrl, required: true),
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
          labelText: 'Expenditure Date',
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
