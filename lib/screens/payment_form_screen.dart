import 'package:flutter/material.dart';

import '../models/payment.dart';

class PaymentFormScreen extends StatefulWidget {
  final Payment? payment;
  final int? nextId;

  const PaymentFormScreen({super.key, this.payment, this.nextId});

  @override
  State<PaymentFormScreen> createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends State<PaymentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountCtrl;
  late final TextEditingController _descriptionCtrl;
  late String _transactionType;
  late String _paymentType;
  late String _bankName;
  late String _type;
  late String _selectName;
  late DateTime _date;

  static const _transactionTypes = ['Received', 'Paid', 'Adjusted'];
  static const _paymentTypes = ['Cash', 'Cheque', 'Bank Transfer', 'Mobile Banking', 'Card'];
  static const _banks = ['Sonali Bank Ltd', 'Dutch Bangla Bank', 'Islami Bank BD', 'Agrani Bank', 'Janata Bank'];
  static const _types = ['Income', 'Expense', 'Asset', 'Liability'];
  static const _names = ['Client A', 'Client B', 'Supplier X', 'Supplier Y', 'Employee 1', 'Employee 2'];

  @override
  void initState() {
    super.initState();
    final p = widget.payment;
    _amountCtrl = TextEditingController(text: p?.amount.toString() ?? '');
    _descriptionCtrl = TextEditingController(text: p?.description ?? '');
    _transactionType = p?.transactionType ?? _transactionTypes.first;
    _paymentType = p?.paymentType ?? _paymentTypes.first;
    _bankName = p?.bankName ?? _banks.first;
    _type = p?.type ?? _types.first;
    _selectName = p?.selectName ?? _names.first;
    _date = p?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_date),
    );
    if (time == null || !mounted) return;
    setState(() {
      _date = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.tryParse(_amountCtrl.text) ?? 0;
    final id = widget.payment?.transId ?? 'PAY-${widget.nextId?.toString().padLeft(3, '0') ?? '001'}';
    final payment = Payment(
      transId: id,
      date: _date,
      transactionType: _transactionType,
      paymentType: _paymentType,
      bankName: _bankName,
      type: _type,
      selectName: _selectName,
      amount: amount,
      description: _descriptionCtrl.text.trim(),
    );
    Navigator.pop(context, payment);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.payment != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Payment' : 'Add Payment'),
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
              _buildDropdown('Transaction Type', _transactionType, _transactionTypes, (v) {
                if (v != null) setState(() => _transactionType = v);
              }),
              const SizedBox(height: 14),
              _buildDropdown('Payment Type', _paymentType, _paymentTypes, (v) {
                if (v != null) setState(() => _paymentType = v);
              }),
              const SizedBox(height: 14),
              _buildDropdown('Bank Name', _bankName, _banks, (v) {
                if (v != null) setState(() => _bankName = v);
              }),
              const SizedBox(height: 14),
              _buildDropdown('Type', _type, _types, (v) {
                if (v != null) setState(() => _type = v);
              }),
              const SizedBox(height: 14),
              _buildDropdown('Select Name', _selectName, _names, (v) {
                if (v != null) setState(() => _selectName = v);
              }),
              const SizedBox(height: 14),
              _buildDateTimeField(),
              const SizedBox(height: 14),
              _buildField('Payment Amount', _amountCtrl, keyboardType: TextInputType.number, required: true),
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

  Widget _buildDateTimeField() {
    return InkWell(
      onTap: _pickDateTime,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Payment Date/Time',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${_date.day.toString().padLeft(2, '0')}/${_date.month.toString().padLeft(2, '0')}/${_date.year} ${_date.hour.toString().padLeft(2, '0')}:${_date.minute.toString().padLeft(2, '0')}'),
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
