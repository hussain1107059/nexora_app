import 'package:flutter/material.dart';

import '../models/production.dart';

class ProductionFormScreen extends StatefulWidget {
  final Production? production;

  const ProductionFormScreen({super.key, this.production});

  @override
  State<ProductionFormScreen> createState() => _ProductionFormScreenState();
}

class _ProductionFormScreenState extends State<ProductionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _chalanCtrl;
  late final TextEditingController _productNameCtrl;
  late final TextEditingController _numberOfBagsCtrl;
  late final TextEditingController _productQuantityCtrl;
  late final TextEditingController _remarksCtrl;
  late String _factory;
  late String _warehouse;
  late DateTime _date;
  late List<ProductionItem> _items;
  int _editingIndex = -1;

  static const _factories = ['Factory A', 'Factory B', 'Factory C', 'Factory D'];
  static const _warehouses = ['Main Warehouse', 'North Storage', 'South Storage', 'East Storage', 'West Storage'];
  static const _productOptions = ['Rice BR-28', 'Wheat', 'Maize', 'Wheat Flour', 'DAP Fertilizer', 'Urea', 'TSP'];

  @override
  void initState() {
    super.initState();
    final s = widget.production;
    _chalanCtrl = TextEditingController(text: s?.chalanNo ?? '');
    _productNameCtrl = TextEditingController();
    _numberOfBagsCtrl = TextEditingController();
    _productQuantityCtrl = TextEditingController();
    _remarksCtrl = TextEditingController(text: s?.remarks ?? '');
    _factory = s?.factory ?? _factories.first;
    _warehouse = s?.warehouse ?? _warehouses.first;
    _date = s?.date ?? DateTime.now();
    _items = s?.items != null ? List.from(s!.items) : [];
  }

  @override
  void dispose() {
    _chalanCtrl.dispose();
    _productNameCtrl.dispose();
    _numberOfBagsCtrl.dispose();
    _productQuantityCtrl.dispose();
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

  void _addItem() {
    final product = _productNameCtrl.text.trim();
    final bags = double.tryParse(_numberOfBagsCtrl.text);
    final qty = double.tryParse(_productQuantityCtrl.text);
    if (product.isEmpty || bags == null || qty == null || bags <= 0 || qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid product name, number of bags, and quantity')),
      );
      return;
    }
    final item = ProductionItem(productName: product, numberOfBags: bags, productQuantity: qty);
    setState(() {
      if (_editingIndex >= 0 && _editingIndex < _items.length) {
        _items[_editingIndex] = item;
        _editingIndex = -1;
      } else {
        _items.add(item);
      }
      _productNameCtrl.clear();
      _numberOfBagsCtrl.clear();
      _productQuantityCtrl.clear();
    });
  }

  void _editItem(int index) {
    final item = _items[index];
    _productNameCtrl.text = item.productName;
    _numberOfBagsCtrl.text = item.numberOfBags.toString();
    _productQuantityCtrl.text = item.productQuantity.toString();
    setState(() => _editingIndex = index);
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
      if (_editingIndex == index) {
        _editingIndex = -1;
        _productNameCtrl.clear();
        _numberOfBagsCtrl.clear();
        _productQuantityCtrl.clear();
      } else if (_editingIndex > index) {
        _editingIndex--;
      }
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
    final production = Production(
      date: _date,
      chalanNo: _chalanCtrl.text.trim(),
      factory: _factory,
      warehouse: _warehouse,
      remarks: _remarksCtrl.text.trim(),
      items: List.from(_items),
    );
    Navigator.pop(context, production);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.production != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Production' : 'Add Production'),
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
              _buildField('Chalan No', _chalanCtrl, required: true),
              const SizedBox(height: 14),
              _buildDropdown('Factory', _factory, _factories, (v) {
                if (v != null) setState(() => _factory = v);
              }),
              const SizedBox(height: 14),
              _buildDropdown('Warehouse', _warehouse, _warehouses, (v) {
                if (v != null) setState(() => _warehouse = v);
              }),
              const SizedBox(height: 20),
              const Text('Products', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF19243A))),
              const SizedBox(height: 12),
              _buildDropdown('Supply Product Name', _productNameCtrl.text.isEmpty ? _productOptions.first : _productNameCtrl.text, _productOptions, (v) {
                if (v != null) _productNameCtrl.text = v;
              }),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildField('Number of Bags', _numberOfBagsCtrl, keyboardType: TextInputType.number, required: true),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildField('Product Quantity', _productQuantityCtrl, keyboardType: TextInputType.number, required: true),
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
              const SizedBox(height: 20),
              _buildField('Remarks', _remarksCtrl, maxLines: 2),
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
                Expanded(flex: 3, child: Text('Product', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
                Expanded(flex: 2, child: Text('Bags', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
                Expanded(flex: 2, child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
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
                  Expanded(flex: 3, child: Text(item.productName, style: const TextStyle(fontSize: 12))),
                  Expanded(flex: 2, child: Text(item.numberOfBags.toStringAsFixed(0), style: const TextStyle(fontSize: 12))),
                  Expanded(flex: 2, child: Text(item.productQuantity.toStringAsFixed(0), style: const TextStyle(fontSize: 12))),
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
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: _pickDate,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Production Date',
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
      key: ValueKey('${label}_$value'),
      initialValue: value,
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
