import 'package:flutter/material.dart';

import '../models/expenditure.dart';

class ExpenditureFormScreen extends StatefulWidget {
  final Expenditure? expenditure;

  const ExpenditureFormScreen({super.key, this.expenditure});

  @override
  State<ExpenditureFormScreen> createState() => _ExpenditureFormScreenState();
}

class _ExpenditureFormScreenState extends State<ExpenditureFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _sellerNameCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _itemNameCtrl;
  late final TextEditingController _saleRateCtrl;
  late final TextEditingController _quantityCtrl;
  late String _type;
  late String _paymentType;
  late String? _bankName;
  late DateTime _date;
  late List<ExpenditureItem> _items;
  int _editingIndex = -1;

  static const _expenditureTypes = ['Feed', 'Medicine', 'Equipment', 'Labour', 'Transport', 'Utilities', 'Office', 'Other'];
  static const _paymentMethods = ['Cash', 'Bank'];
  static const _banks = ['Sonali Bank Ltd', 'Dutch Bangla Bank', 'Islami Bank BD', 'Agrani Bank', 'Janata Bank'];

  @override
  void initState() {
    super.initState();
    final e = widget.expenditure;
    _sellerNameCtrl = TextEditingController(text: e?.sellerName ?? '');
    _descriptionCtrl = TextEditingController(text: e?.description ?? '');
    _itemNameCtrl = TextEditingController();
    _saleRateCtrl = TextEditingController();
    _quantityCtrl = TextEditingController();
    _type = e?.type ?? _expenditureTypes.first;
    _paymentType = e?.paymentType ?? _paymentMethods.first;
    _bankName = e?.bankName;
    _date = e?.date ?? DateTime.now();
    _items = e?.items != null ? List.from(e!.items) : [];
  }

  @override
  void dispose() {
    _sellerNameCtrl.dispose();
    _descriptionCtrl.dispose();
    _itemNameCtrl.dispose();
    _saleRateCtrl.dispose();
    _quantityCtrl.dispose();
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

  void _addItem() {
    final name = _itemNameCtrl.text.trim();
    final rate = double.tryParse(_saleRateCtrl.text);
    final qty = double.tryParse(_quantityCtrl.text);
    if (name.isEmpty || rate == null || qty == null || rate <= 0 || qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid item name, sale rate, and quantity')),
      );
      return;
    }
    final item = ExpenditureItem(itemName: name, saleRate: rate, quantity: qty);
    setState(() {
      if (_editingIndex >= 0 && _editingIndex < _items.length) {
        _items[_editingIndex] = item;
        _editingIndex = -1;
      } else {
        _items.add(item);
      }
      _itemNameCtrl.clear();
      _saleRateCtrl.clear();
      _quantityCtrl.clear();
    });
  }

  void _editItem(int index) {
    final item = _items[index];
    _itemNameCtrl.text = item.itemName;
    _saleRateCtrl.text = item.saleRate.toString();
    _quantityCtrl.text = item.quantity.toString();
    setState(() => _editingIndex = index);
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
      if (_editingIndex == index) {
        _editingIndex = -1;
        _itemNameCtrl.clear();
        _saleRateCtrl.clear();
        _quantityCtrl.clear();
      } else if (_editingIndex > index) {
        _editingIndex--;
      }
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_paymentType == 'Bank' && (_bankName == null || _bankName!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a bank name')),
      );
      return;
    }
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one item')),
      );
      return;
    }
    final expenditure = Expenditure(
      date: _date,
      type: _type,
      paymentType: _paymentType,
      bankName: _paymentType == 'Bank' ? _bankName : null,
      sellerName: _sellerNameCtrl.text.trim(),
      description: _descriptionCtrl.text.trim(),
      items: List.from(_items),
    );
    Navigator.pop(context, expenditure);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDropdown('Expenditure Type', _type, _expenditureTypes, (v) {
                if (v != null) setState(() => _type = v);
              }),
              const SizedBox(height: 14),
              _buildDateField(),
              const SizedBox(height: 14),
              _buildDropdown('Payment Type', _paymentType, _paymentMethods, (v) {
                if (v != null) setState(() => _paymentType = v);
              }),
              if (_paymentType == 'Bank') ...[
                const SizedBox(height: 14),
                _buildDropdown('Bank Name', _bankName ?? _banks.first, _banks, (v) {
                  if (v != null) setState(() => _bankName = v);
                }),
              ],
              const SizedBox(height: 14),
              _buildField('Seller Name', _sellerNameCtrl, required: true),
              const SizedBox(height: 14),
              _buildField('Description', _descriptionCtrl, maxLines: 2),
              const SizedBox(height: 20),
              const Text('Products', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF19243A))),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildField('Item Name', _itemNameCtrl, required: true),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: _buildField('Rate', _saleRateCtrl, keyboardType: TextInputType.number, required: true),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: _buildField('Qty', _quantityCtrl, keyboardType: TextInputType.number, required: true),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _addItem,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _editingIndex >= 0 ? const Color(0xFFD97706) : const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: Text(_editingIndex >= 0 ? 'Update' : 'Add', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
              if (_items.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildItemsTable(),
              ],
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

  Widget _buildItemsTable() {
    final totalAmount = _items.fold(0.0, (sum, item) => sum + item.total);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: const Row(
              children: [
                Expanded(flex: 3, child: Text('Item', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
                Expanded(flex: 2, child: Text('Rate', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
                Expanded(flex: 2, child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
                Expanded(flex: 2, child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
                SizedBox(width: 60),
              ],
            ),
          ),
          ...List.generate(_items.length, (index) {
            final item = _items[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
              ),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Text(item.itemName, style: const TextStyle(fontSize: 12))),
                  Expanded(flex: 2, child: Text('\$${item.saleRate.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12))),
                  Expanded(flex: 2, child: Text(item.quantity.toStringAsFixed(0), style: const TextStyle(fontSize: 12))),
                  Expanded(flex: 2, child: Text('\$${item.total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                  SizedBox(
                    width: 60,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 16, color: Color(0xFF2563EB)),
                          onPressed: () => _editItem(index),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                          onPressed: () => _deleteItem(index),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Spacer(),
                Text('Total: \$${totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF19243A))),
              ],
            ),
          ),
        ],
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
            Text(_formatDate(_date)),
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
