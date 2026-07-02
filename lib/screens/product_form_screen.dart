import 'package:flutter/material.dart';

import '../models/product_item.dart';

class ProductFormScreen extends StatefulWidget {
  final ProductItem? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _priceCtrl;
  String _category = 'Broiler Feed';
  String _package = 'Bag (50 kg)';

  static const _categories = [
    'Broiler Feed',
    'Layer Feed',
    'Chick Feed',
    'Medicine',
    'Supplement',
  ];

  static const _packages = [
    'Bag (50 kg)',
    'Bag (40 kg)',
    'Bag (25 kg)',
    'Box (100 pcs)',
    'Box (50 pcs)',
    'Packet (1 kg)',
    'Packet (500 g)',
    'Piece',
    'Liter',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _priceCtrl = TextEditingController(text: p?.price.toString() ?? '');
    if (p != null) {
      _category = p.category;
      _package = p.package;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final price = double.tryParse(_priceCtrl.text) ?? 0;
    final product = ProductItem(
      category: _category,
      name: _nameCtrl.text.trim(),
      package: _package,
      price: price,
    );
    Navigator.pop(context, product);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'Add Product'),
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
              _buildDropdown('Category', _category, _categories),
              const SizedBox(height: 14),
              _buildField('Product Name', _nameCtrl, required: true),
              const SizedBox(height: 14),
              _buildDropdown('Package', _package, _packages),
              const SizedBox(height: 14),
              _buildField('Price', _priceCtrl, keyboardType: TextInputType.number, required: true),
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

  Widget _buildField(String label, TextEditingController ctrl, {TextInputType? keyboardType, bool required = false}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
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

  Widget _buildDropdown(String label, String value, List<String> items) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (v) {
        if (v != null) {
          setState(() {
            if (label == 'Category') {
              _category = v;
            } else if (label == 'Package') {
              _package = v;
            }
          });
        }
      },
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
