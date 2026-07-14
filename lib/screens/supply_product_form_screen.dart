import 'package:flutter/material.dart';

import '../models/supply_product.dart';

class SupplyProductFormScreen extends StatefulWidget {
  final SupplyProduct? product;

  const SupplyProductFormScreen({super.key, this.product});

  @override
  State<SupplyProductFormScreen> createState() => _SupplyProductFormScreenState();
}

class _SupplyProductFormScreenState extends State<SupplyProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _chalanNoCtrl;
  late final TextEditingController _partyNoCtrl;
  late final TextEditingController _serialNoCtrl;
  late final TextEditingController _remarksCtrl;
  late final TextEditingController _productNameCtrl;
  late final TextEditingController _buyRateCtrl;
  late final TextEditingController _numberOfBagsCtrl;
  late final TextEditingController _quantityKgCtrl;
  late final TextEditingController _weightPerBagMonCtrl;
  late String _supplier;
  late String _truckNumber;
  late String _warehouse;
  late DateTime _chalanDate;
  late List<SupplyProductItem> _items;
  int _editingIndex = -1;

  static const _suppliers = ['Sonali Suppliers', 'Alim Store', 'Karim Brothers', 'Bashundhara', 'Rahim Traders'];
  static const _trucks = ['Truck A (DA-1234)', 'Truck B (DA-5678)', 'Truck C (DA-9012)', 'Truck D (DA-3456)'];
  static const _warehouses = ['Main Warehouse', 'North Storage', 'South Storage', 'East Storage', 'West Storage'];
  static const _productOptions = ['DAP Fertilizer', 'Urea', 'TSP', 'Wheat', 'Maize', 'Rice BR-28'];

  @override
  void initState() {
    super.initState();
    final s = widget.product;
    _chalanNoCtrl = TextEditingController(text: s?.chalanNo ?? '');
    _partyNoCtrl = TextEditingController(text: s?.partyNo ?? '');
    _serialNoCtrl = TextEditingController(text: s?.serialNo ?? '');
    _remarksCtrl = TextEditingController(text: s?.remarks ?? '');
    _productNameCtrl = TextEditingController();
    _buyRateCtrl = TextEditingController();
    _numberOfBagsCtrl = TextEditingController();
    _quantityKgCtrl = TextEditingController();
    _weightPerBagMonCtrl = TextEditingController();
    _supplier = s?.supplier ?? _suppliers.first;
    _truckNumber = s?.truckNumber ?? _trucks.first;
    _warehouse = s?.items.isNotEmpty == true ? s!.items.first.warehouse : _warehouses.first;
    _chalanDate = s?.chalanDate ?? DateTime.now();
    _items = s?.items != null ? List.from(s!.items) : [];
  }

  @override
  void dispose() {
    _chalanNoCtrl.dispose();
    _partyNoCtrl.dispose();
    _serialNoCtrl.dispose();
    _remarksCtrl.dispose();
    _productNameCtrl.dispose();
    _buyRateCtrl.dispose();
    _numberOfBagsCtrl.dispose();
    _quantityKgCtrl.dispose();
    _weightPerBagMonCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _chalanDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _chalanDate = picked);
    }
  }

  void _addItem() {
    final product = _productNameCtrl.text.trim();
    final rate = double.tryParse(_buyRateCtrl.text);
    final bags = int.tryParse(_numberOfBagsCtrl.text);
    final kg = double.tryParse(_quantityKgCtrl.text);
    final weight = double.tryParse(_weightPerBagMonCtrl.text);
    if (product.isEmpty || rate == null || bags == null || kg == null || weight == null || rate <= 0 || bags <= 0 || kg <= 0 || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid product details')),
      );
      return;
    }
    final item = SupplyProductItem(
      productName: product,
      buyRate: rate,
      numberOfBags: bags,
      quantityKg: kg,
      weightPerBagMon: weight,
      warehouse: _warehouse,
    );
    setState(() {
      if (_editingIndex >= 0 && _editingIndex < _items.length) {
        _items[_editingIndex] = item;
        _editingIndex = -1;
      } else {
        _items.add(item);
      }
      _productNameCtrl.clear();
      _buyRateCtrl.clear();
      _numberOfBagsCtrl.clear();
      _quantityKgCtrl.clear();
      _weightPerBagMonCtrl.clear();
    });
  }

  void _editItem(int index) {
    final item = _items[index];
    _productNameCtrl.text = item.productName;
    _buyRateCtrl.text = item.buyRate.toString();
    _numberOfBagsCtrl.text = item.numberOfBags.toString();
    _quantityKgCtrl.text = item.quantityKg.toString();
    _weightPerBagMonCtrl.text = item.weightPerBagMon.toString();
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
        _buyRateCtrl.clear();
        _numberOfBagsCtrl.clear();
        _quantityKgCtrl.clear();
        _weightPerBagMonCtrl.clear();
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
    final product = SupplyProduct(
      chalanDate: _chalanDate,
      chalanNo: _chalanNoCtrl.text.trim(),
      partyNo: _partyNoCtrl.text.trim(),
      serialNo: _serialNoCtrl.text.trim(),
      supplier: _supplier,
      truckNumber: _truckNumber,
      remarks: _remarksCtrl.text.trim(),
      items: List.from(_items),
    );
    Navigator.pop(context, product);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Supply' : 'Add Supply'),
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
              _buildField('Chalan No', _chalanNoCtrl, required: true),
              const SizedBox(height: 14),
              _buildField('Party No', _partyNoCtrl),
              const SizedBox(height: 14),
              _buildField('Serial No', _serialNoCtrl),
              const SizedBox(height: 14),
              _buildDropdown('Supplier', _supplier, _suppliers, (v) {
                if (v != null) setState(() => _supplier = v);
              }),
              const SizedBox(height: 14),
              _buildDropdown('Truck Number', _truckNumber, _trucks, (v) {
                if (v != null) setState(() => _truckNumber = v);
              }),
              const SizedBox(height: 14),
              _buildField('Remarks', _remarksCtrl, maxLines: 2),
              const SizedBox(height: 20),
              const Text('Products', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF19243A))),
              const SizedBox(height: 12),
              _buildDropdown('Product', _productNameCtrl.text.isEmpty ? _productOptions.first : _productNameCtrl.text, _productOptions, (v) {
                if (v != null) _productNameCtrl.text = v;
              }),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildField('Buy Rate (KG)', _buyRateCtrl, keyboardType: TextInputType.number, required: true),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildField('No of Bags', _numberOfBagsCtrl, keyboardType: TextInputType.number, required: true),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildField('Quantity (KG)', _quantityKgCtrl, keyboardType: TextInputType.number, required: true),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildField('Wt/Bag (KG)', _weightPerBagMonCtrl, keyboardType: TextInputType.number, required: true),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown('Warehouse', _warehouse, _warehouses, (v) {
                      if (v != null) setState(() => _warehouse = v);
                    }),
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
                  Expanded(flex: 2, child: Text('\$${item.buyRate.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12))),
                  Expanded(flex: 2, child: Text('${item.quantityKg.toStringAsFixed(0)} KG', style: const TextStyle(fontSize: 12))),
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
          labelText: 'Chalan Date',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_formatDate(_chalanDate)),
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
