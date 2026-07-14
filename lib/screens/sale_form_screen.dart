import 'package:flutter/material.dart';

import '../models/sale.dart';

class SaleFormScreen extends StatefulWidget {
  final Sale? sale;

  const SaleFormScreen({super.key, this.sale});

  @override
  State<SaleFormScreen> createState() => _SaleFormScreenState();
}

class _SaleFormScreenState extends State<SaleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _remarksCtrl;
  late final TextEditingController _chalanNoCtrl;
  late final TextEditingController _partyNoCtrl;
  late final TextEditingController _serialNoCtrl;
  late final TextEditingController _productNameCtrl;
  late final TextEditingController _saleRateCtrl;
  late final TextEditingController _packageWeightCtrl;
  late final TextEditingController _quantityCtrl;
  late String _saleType;
  late String _customer;
  late String _truck;
  late String _warehouse;
  late DateTime _date;
  late List<SaleItem> _items;
  int _editingIndex = -1;

  static const _saleTypes = ['Whole Sale', 'Retail'];
  static const _customers = ['Green Agro', 'Rahim Store', 'Hasan Enterprise', 'Shah Cement', 'Alim Store'];
  static const _trucks = ['Truck A (DA-1234)', 'Truck B (DA-5678)', 'Truck C (DA-9012)', 'Truck D (DA-3456)'];
  static const _warehouses = ['Main Warehouse', 'North Storage', 'South Storage', 'East Storage', 'West Storage'];
  static const _productOptions = ['Rice BR-28', 'Wheat', 'Maize', 'DAP Fertilizer', 'Urea', 'TSP'];

  @override
  void initState() {
    super.initState();
    final s = widget.sale;
    _remarksCtrl = TextEditingController(text: s?.remarks ?? '');
    _chalanNoCtrl = TextEditingController(text: s?.chalanNo ?? '');
    _partyNoCtrl = TextEditingController(text: s?.partyNo ?? '');
    _serialNoCtrl = TextEditingController(text: s?.serialNo ?? '');
    _productNameCtrl = TextEditingController();
    _saleRateCtrl = TextEditingController();
    _packageWeightCtrl = TextEditingController();
    _quantityCtrl = TextEditingController();
    _saleType = s?.saleType ?? _saleTypes.first;
    _customer = s?.customer ?? _customers.first;
    _truck = s?.truck ?? _trucks.first;
    _warehouse = s?.items.isNotEmpty == true ? s!.items.first.warehouse : _warehouses.first;
    _date = s?.date ?? DateTime.now();
    _items = s?.items != null ? List.from(s!.items) : [];
  }

  @override
  void dispose() {
    _remarksCtrl.dispose();
    _chalanNoCtrl.dispose();
    _partyNoCtrl.dispose();
    _serialNoCtrl.dispose();
    _productNameCtrl.dispose();
    _saleRateCtrl.dispose();
    _packageWeightCtrl.dispose();
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
    final product = _productNameCtrl.text.trim();
    final rate = double.tryParse(_saleRateCtrl.text);
    final weight = double.tryParse(_packageWeightCtrl.text);
    final qty = double.tryParse(_quantityCtrl.text);
    if (product.isEmpty || rate == null || weight == null || qty == null || rate <= 0 || weight <= 0 || qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid product name, rate, weight, and quantity')),
      );
      return;
    }
    final item = SaleItem(
      productName: product,
      saleRate: rate,
      warehouse: _warehouse,
      packageWeight: weight,
      quantity: qty,
    );
    setState(() {
      if (_editingIndex >= 0 && _editingIndex < _items.length) {
        _items[_editingIndex] = item;
        _editingIndex = -1;
      } else {
        _items.add(item);
      }
      _productNameCtrl.clear();
      _saleRateCtrl.clear();
      _packageWeightCtrl.clear();
      _quantityCtrl.clear();
    });
  }

  void _editItem(int index) {
    final item = _items[index];
    _productNameCtrl.text = item.productName;
    _saleRateCtrl.text = item.saleRate.toString();
    _packageWeightCtrl.text = item.packageWeight.toString();
    _quantityCtrl.text = item.quantity.toString();
    setState(() {
      _editingIndex = index;
      _warehouse = item.warehouse;
    });
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
      if (_editingIndex == index) {
        _editingIndex = -1;
        _productNameCtrl.clear();
        _saleRateCtrl.clear();
        _packageWeightCtrl.clear();
        _quantityCtrl.clear();
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
    final sale = Sale(
      date: _date,
      saleType: _saleType,
      customer: _customer,
      chalanNo: _chalanNoCtrl.text.trim(),
      partyNo: _partyNoCtrl.text.trim(),
      serialNo: _serialNoCtrl.text.trim(),
      truck: _truck,
      remarks: _remarksCtrl.text.trim(),
      items: List.from(_items),
    );
    Navigator.pop(context, sale);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.sale != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Sale' : 'Add Sale'),
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
              _buildDropdown('Sale Type', _saleType, _saleTypes, (v) {
                if (v != null) setState(() => _saleType = v);
              }),
              const SizedBox(height: 14),
              _buildDropdown('Customer', _customer, _customers, (v) {
                if (v != null) setState(() => _customer = v);
              }),
              const SizedBox(height: 14),
              _buildField('Chalan No', _chalanNoCtrl),
              const SizedBox(height: 14),
              _buildField('Party No', _partyNoCtrl),
              const SizedBox(height: 14),
              _buildField('Serial No', _serialNoCtrl, required: true),
              const SizedBox(height: 14),
              _buildDropdown('Truck', _truck, _trucks, (v) {
                if (v != null) setState(() => _truck = v);
              }),
              const SizedBox(height: 14),
              _buildField('Remarks', _remarksCtrl, maxLines: 2),
              const SizedBox(height: 20),
              const Text('Products', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF19243A))),
              const SizedBox(height: 12),
              _buildDropdown('Product Name', _productNameCtrl.text.isEmpty ? _productOptions.first : _productNameCtrl.text, _productOptions, (v) {
                if (v != null) _productNameCtrl.text = v;
              }),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildField('Sale Rate', _saleRateCtrl, keyboardType: TextInputType.number, required: true),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: _buildDropdown('Warehouse', _warehouse, _warehouses, (v) {
                      if (v != null) setState(() => _warehouse = v);
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildField('Pkg Weight', _packageWeightCtrl, keyboardType: TextInputType.number, required: true),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: _buildField('Quantity', _quantityCtrl, keyboardType: TextInputType.number, required: true),
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
                Expanded(flex: 3, child: Text('Product', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
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
                  Expanded(flex: 3, child: Text(item.productName, style: const TextStyle(fontSize: 12))),
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
          labelText: 'Sale Date',
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
