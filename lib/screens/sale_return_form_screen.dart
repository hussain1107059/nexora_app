import 'package:flutter/material.dart';

import '../models/sale.dart';
import '../models/sale_return.dart';

class SaleReturnFormScreen extends StatefulWidget {
  final SaleReturn? saleReturn;

  const SaleReturnFormScreen({super.key, this.saleReturn});

  @override
  State<SaleReturnFormScreen> createState() => _SaleReturnFormScreenState();
}

class _SaleReturnFormScreenState extends State<SaleReturnFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _invoiceCtrl;
  late final TextEditingController _reasonCtrl;
  late final TextEditingController _qtyCtrl;
  late DateTime _date;
  Sale? _foundSale;
  late List<SaleReturnItem> _returnItems;
  final Set<int> _selectedIndexes = {};

  @override
  void initState() {
    super.initState();
    final r = widget.saleReturn;
    _invoiceCtrl = TextEditingController(text: r?.invoiceNo ?? '');
    _reasonCtrl = TextEditingController(text: r?.reason ?? '');
    _qtyCtrl = TextEditingController();
    _date = r?.date ?? DateTime.now();
    _returnItems = r?.items != null ? List.from(r!.items) : [];
  }

  @override
  void dispose() {
    _invoiceCtrl.dispose();
    _reasonCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _searchInvoice() {
    final inv = _invoiceCtrl.text.trim();
    if (inv.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an invoice number')),
      );
      return;
    }
    final sale = findSaleByInvoice(inv);
    if (sale == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No sale found with this invoice number')),
      );
      setState(() {
        _foundSale = null;
        _selectedIndexes.clear();
      });
      return;
    }
    setState(() {
      _foundSale = sale;
      _selectedIndexes.clear();
      _returnItems.clear();
    });
  }

  void _toggleProduct(int index) {
    setState(() {
      if (_selectedIndexes.contains(index)) {
        _selectedIndexes.remove(index);
        _returnItems.removeWhere(
          (item) => item.productName == _foundSale!.items[index].productName,
        );
      } else {
        _selectedIndexes.add(index);
      }
    });
  }

  void _addReturnItem(int saleItemIndex) {
    final item = _foundSale!.items[saleItemIndex];
    if (_returnItems.any((ri) => ri.productName == item.productName)) return;

    showDialog(
      context: context,
      builder: (ctx) {
        final qtyCtrl = TextEditingController();
        return AlertDialog(
          title: Text(item.productName),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _infoRow('Unit Price', '\$${item.saleRate.toStringAsFixed(2)}'),
              _infoRow('Sold Qty', item.quantity.toStringAsFixed(0)),
              const SizedBox(height: 12),
              TextField(
                controller: qtyCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Return Quantity',
                  filled: true,
                  fillColor: const Color(0xFFF4F7FB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final qty = double.tryParse(qtyCtrl.text);
                if (qty == null || qty <= 0) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('Enter valid quantity')),
                  );
                  return;
                }
                Navigator.pop(ctx);
                setState(() {
                  _returnItems.add(SaleReturnItem(
                    productName: item.productName,
                    unitPrice: item.saleRate,
                    quantity: qty,
                    warehouse: item.warehouse,
                  ));
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editItem(int index) {
    final ri = _returnItems[index];
    _qtyCtrl.text = ri.quantity.toString();
    showDialog(
      context: context,
      builder: (ctx) {
        final qtyCtrl = TextEditingController(text: ri.quantity.toString());
        return AlertDialog(
          title: Text(ri.productName),
          content: TextField(
            controller: qtyCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Return Quantity',
              filled: true,
              fillColor: const Color(0xFFF4F7FB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final qty = double.tryParse(qtyCtrl.text);
                if (qty == null || qty <= 0) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('Enter valid quantity')),
                  );
                  return;
                }
                Navigator.pop(ctx);
                setState(() {
                  _returnItems[index] = SaleReturnItem(
                    productName: ri.productName,
                    unitPrice: ri.unitPrice,
                    quantity: qty,
                    warehouse: ri.warehouse,
                  );
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD97706),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _deleteItem(int index) {
    final productName = _returnItems[index].productName;
    setState(() {
      _returnItems.removeAt(index);
      final saleIdx = _foundSale?.items.indexWhere((i) => i.productName == productName);
      if (saleIdx != null && saleIdx >= 0) _selectedIndexes.remove(saleIdx);
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_foundSale == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please search and select a sale invoice')),
      );
      return;
    }
    if (_returnItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one return item')),
      );
      return;
    }
    final sr = SaleReturn(
      date: _date,
      invoiceNo: _foundSale!.serialNo,
      organization: _foundSale!.customer,
      reason: _reasonCtrl.text.trim(),
      items: List.from(_returnItems),
    );
    Navigator.pop(context, sr);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.saleReturn != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Sale Return' : 'Add Sale Return'),
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
              Row(
                children: [
                  Expanded(
                    child: _buildField('Search Sale Invoice', _invoiceCtrl, required: true, hintText: 'search with 482326'),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _searchInvoice,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Search', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildField('Reason', _reasonCtrl, maxLines: 2),
              if (_foundSale != null) ...[
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Color(0xFF2563EB), size: 18),
                      const SizedBox(width: 8),
                      Text('Invoice: ${_foundSale!.serialNo} — ${_foundSale!.customer}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF19243A))),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Text('Select Products to Return',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF19243A))),
                const SizedBox(height: 8),
                ..._foundSale!.items.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final item = entry.value;
                  final isSelected = _selectedIndexes.contains(idx);
                  final alreadyAdded = _returnItems.any((ri) => ri.productName == item.productName);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFEEEEEE),
                      ),
                    ),
                    child: ListTile(
                      dense: true,
                      leading: Checkbox(
                        value: isSelected,
                        onChanged: alreadyAdded ? null : (_) => _toggleProduct(idx),
                        activeColor: const Color(0xFF2563EB),
                      ),
                      title: Text(item.productName, style: const TextStyle(fontSize: 13)),
                      subtitle: Text('Qty: ${item.quantity.toStringAsFixed(0)} | Price: \$${item.saleRate.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                      trailing: Text('\$${item.total.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF19243A))),
                      onTap: alreadyAdded ? null : () => _toggleProduct(idx),
                    ),
                  );
                }),
                if (_selectedIndexes.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        for (final idx in _selectedIndexes) {
                          _addReturnItem(idx);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Add Selected Products', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ],
              if (_returnItems.isNotEmpty) ...[
                const SizedBox(height: 20),
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
                Expanded(flex: 2, child: Text('Price', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
                Expanded(flex: 2, child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
                Expanded(flex: 2, child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
                SizedBox(width: 60),
              ],
            ),
          ),
          ...List.generate(_returnItems.length, (index) {
            final item = _returnItems[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
              ),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Text(item.productName, style: const TextStyle(fontSize: 12))),
                  Expanded(flex: 2, child: Text('\$${item.unitPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12))),
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
            child: Row(
              children: [
                const Spacer(),
                Text('Total: \$${_returnItems.fold(0.0, (s, i) => s + i.total).toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF19243A))),
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
          labelText: 'Return Date',
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

  Widget _buildField(String label, TextEditingController ctrl, {bool required = false, int maxLines = 1, String? hintText}) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: required ? (v) => (v == null || v.trim().isEmpty) ? '$label is required' : null : null,
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF19243A))),
        ],
      ),
    );
  }
}
