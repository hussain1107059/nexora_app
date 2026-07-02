import 'package:flutter/material.dart';

import '../models/hatchery_income.dart';

class HatcheryIncomeFormScreen extends StatefulWidget {
  final HatcheryIncome? income;

  const HatcheryIncomeFormScreen({super.key, this.income});

  @override
  State<HatcheryIncomeFormScreen> createState() => _HatcheryIncomeFormScreenState();
}

class _HatcheryIncomeFormScreenState extends State<HatcheryIncomeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _buyerNameCtrl;
  late final TextEditingController _buyerAddressCtrl;
  late final TextEditingController _remarksCtrl;
  late final TextEditingController _productNameCtrl;
  late final TextEditingController _unitPriceCtrl;
  late final TextEditingController _quantityCtrl;
  late String _productType;
  late DateTime _date;
  late List<HatcheryIncomeItem> _items;

  int? _editingIndex;

  static const _productTypes = ['Chick', 'Egg', 'Feed', 'Medicine', 'Equipment', 'Other'];

  @override
  void initState() {
    super.initState();
    final h = widget.income;
    _buyerNameCtrl = TextEditingController(text: h?.buyerName ?? '');
    _buyerAddressCtrl = TextEditingController(text: h?.buyerAddress ?? '');
    _remarksCtrl = TextEditingController(text: h?.remarks ?? '');
    _productNameCtrl = TextEditingController();
    _unitPriceCtrl = TextEditingController();
    _quantityCtrl = TextEditingController();
    _productType = _productTypes.first;
    _date = h?.date ?? DateTime.now();
    _items = h != null ? h.items.map((e) => HatcheryIncomeItem(type: e.type, productName: e.productName, unitPrice: e.unitPrice, quantity: e.quantity)).toList() : [];
  }

  @override
  void dispose() {
    _buyerNameCtrl.dispose();
    _buyerAddressCtrl.dispose();
    _remarksCtrl.dispose();
    _productNameCtrl.dispose();
    _unitPriceCtrl.dispose();
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
    final name = _productNameCtrl.text.trim();
    final price = double.tryParse(_unitPriceCtrl.text);
    final qty = int.tryParse(_quantityCtrl.text);
    if (name.isEmpty || price == null || qty == null || qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill product name, unit price, and quantity')),
      );
      return;
    }
    setState(() {
      if (_editingIndex != null) {
        _items[_editingIndex!] = HatcheryIncomeItem(type: _productType, productName: name, unitPrice: price, quantity: qty);
        _editingIndex = null;
      } else {
        _items.add(HatcheryIncomeItem(type: _productType, productName: name, unitPrice: price, quantity: qty));
      }
      _productNameCtrl.clear();
      _unitPriceCtrl.clear();
      _quantityCtrl.clear();
      _productType = _productTypes.first;
    });
  }

  void _editItem(int index) {
    final item = _items[index];
    setState(() {
      _editingIndex = index;
      _productType = item.type;
      _productNameCtrl.text = item.productName;
      _unitPriceCtrl.text = item.unitPrice.toString();
      _quantityCtrl.text = item.quantity.toString();
    });
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
      if (_editingIndex == index) {
        _editingIndex = null;
        _productNameCtrl.clear();
        _unitPriceCtrl.clear();
        _quantityCtrl.clear();
        _productType = _productTypes.first;
      }
    });
  }

  void _cancelEdit() {
    setState(() {
      _editingIndex = null;
      _productNameCtrl.clear();
      _unitPriceCtrl.clear();
      _quantityCtrl.clear();
      _productType = _productTypes.first;
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one product')),
      );
      return;
    }
    final income = HatcheryIncome(
      date: _date,
      buyerName: _buyerNameCtrl.text.trim(),
      buyerAddress: _buyerAddressCtrl.text.trim(),
      remarks: _remarksCtrl.text.trim(),
      items: List.from(_items),
    );
    Navigator.pop(context, income);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.income != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Hatchery Income' : 'Add Hatchery Income'),
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
              _buildDateField(),
              const SizedBox(height: 14),
              _buildField('Buyer Name', _buyerNameCtrl, required: true),
              const SizedBox(height: 14),
              _buildField('Buyer Address', _buyerAddressCtrl, required: true),
              const SizedBox(height: 14),
              _buildField('Remarks', _remarksCtrl, maxLines: 2),
              const SizedBox(height: 20),
              const Text('Products', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF19243A))),
              const SizedBox(height: 12),
              _buildProductSection(),
              const SizedBox(height: 16),
              if (_items.isNotEmpty) _buildItemsList(),
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

  Widget _buildProductSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildDropdown('Type', _productType, _productTypes, (v) {
            if (v != null) setState(() => _productType = v);
          }),
          const SizedBox(height: 10),
          _buildField('Product Name', _productNameCtrl, required: true),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildField('Unit Price', _unitPriceCtrl, keyboardType: TextInputType.number, required: true)),
              const SizedBox(width: 10),
              Expanded(child: _buildField('Quantity', _quantityCtrl, keyboardType: TextInputType.number, required: true)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _addItem,
                  icon: Icon(_editingIndex != null ? Icons.check : Icons.add),
                  label: Text(_editingIndex != null ? 'Update' : 'Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              if (_editingIndex != null) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _cancelEdit,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text('Product', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                Expanded(flex: 1, child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                Expanded(flex: 1, child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                SizedBox(width: 60),
              ],
            ),
          ),
          ...List.generate(_items.length, (i) {
            final item = _items[i];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: const Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
                color: _editingIndex == i ? const Color(0xFFEFF6FF) : Colors.transparent,
              ),
              child: Row(
                children: [
                  Expanded(flex: 2, child: Text(item.productName, style: const TextStyle(fontSize: 12))),
                  Expanded(flex: 1, child: Text('${item.quantity}', style: const TextStyle(fontSize: 12))),
                  Expanded(flex: 1, child: Text('\$${item.total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                  SizedBox(
                    width: 60,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 16, color: Color(0xFF2563EB)),
                          onPressed: () => _editItem(i),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                          onPressed: () => _deleteItem(i),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('\$${_items.fold(0.0, (sum, item) => sum + item.total).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
