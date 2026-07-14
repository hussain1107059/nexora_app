import 'package:flutter/material.dart';

import '../models/work_order.dart';

class WorkOrderFormScreen extends StatefulWidget {
  final WorkOrder? order;

  const WorkOrderFormScreen({super.key, this.order});

  @override
  State<WorkOrderFormScreen> createState() => _WorkOrderFormScreenState();
}

class _WorkOrderFormScreenState extends State<WorkOrderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _remarksCtrl;
  late final TextEditingController _productNameCtrl;
  late final TextEditingController _quantityCtrl;
  late String _workType;
  late String _organization;
  late DateTime _date;
  late List<WorkOrderItem> _items;
  int _editingIndex = -1;

  static const _workTypes = ['Whole Sale', 'Retail'];
  static const _organizations = ['Green Agro', 'Rahim Store', 'Hasan Enterprise', 'Shah Cement', 'Alim Store'];
  static const _productOptions = ['Rice BR-28', 'Wheat', 'Maize', 'DAP Fertilizer', 'Urea', 'TSP'];

  @override
  void initState() {
    super.initState();
    final s = widget.order;
    _remarksCtrl = TextEditingController(text: s?.remarks ?? '');
    _productNameCtrl = TextEditingController();
    _quantityCtrl = TextEditingController();
    _workType = s?.workType ?? _workTypes.first;
    _organization = s?.organization ?? _organizations.first;
    _date = s?.date ?? DateTime.now();
    _items = s?.items != null ? List.from(s!.items) : [];
  }

  @override
  void dispose() {
    _remarksCtrl.dispose();
    _productNameCtrl.dispose();
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
    final qty = double.tryParse(_quantityCtrl.text);
    if (product.isEmpty || qty == null || qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid product name and quantity')),
      );
      return;
    }
    final item = WorkOrderItem(productName: product, quantity: qty);
    setState(() {
      if (_editingIndex >= 0 && _editingIndex < _items.length) {
        _items[_editingIndex] = item;
        _editingIndex = -1;
      } else {
        _items.add(item);
      }
      _productNameCtrl.clear();
      _quantityCtrl.clear();
    });
  }

  void _editItem(int index) {
    final item = _items[index];
    _productNameCtrl.text = item.productName;
    _quantityCtrl.text = item.quantity.toString();
    setState(() => _editingIndex = index);
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
      if (_editingIndex == index) {
        _editingIndex = -1;
        _productNameCtrl.clear();
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
    final order = WorkOrder(
      date: _date,
      workType: _workType,
      organization: _organization,
      remarks: _remarksCtrl.text.trim(),
      items: List.from(_items),
    );
    Navigator.pop(context, order);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.order != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Work Order' : 'Add Work Order'),
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
              _buildDropdown('Work Type', _workType, _workTypes, (v) {
                if (v != null) setState(() => _workType = v);
              }),
              const SizedBox(height: 14),
              _buildDropdown('Organization', _organization, _organizations, (v) {
                if (v != null) setState(() => _organization = v);
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
                    child: _buildField('Quantity (Bag)', _quantityCtrl, keyboardType: TextInputType.number, required: true),
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
                Expanded(flex: 2, child: Text('Qty (Bag)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
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
                  Expanded(flex: 2, child: Text(item.quantity.toStringAsFixed(0), style: const TextStyle(fontSize: 12))),
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
          labelText: 'Work Order Date',
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
