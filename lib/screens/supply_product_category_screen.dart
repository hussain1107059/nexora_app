import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/supply_product_category.dart';
import 'supply_product_category_detail_screen.dart';
import 'supply_product_category_form_screen.dart';

class SupplyProductCategoryScreen extends StatefulWidget {
  const SupplyProductCategoryScreen({super.key});

  @override
  State<SupplyProductCategoryScreen> createState() => _SupplyProductCategoryScreenState();
}

class _SupplyProductCategoryScreenState extends State<SupplyProductCategoryScreen> {
  final List<SupplyProductCategory> _categories = [
    const SupplyProductCategory(productName: 'DAP Fertilizer'),
    const SupplyProductCategory(productName: 'Urea'),
    const SupplyProductCategory(productName: 'TSP'),
    const SupplyProductCategory(productName: 'Wheat'),
    const SupplyProductCategory(productName: 'Maize'),
  ];

  void _openForm([SupplyProductCategory? cat]) async {
    final result = await Navigator.push<SupplyProductCategory>(
      context,
      MaterialPageRoute(builder: (_) => SupplyProductCategoryFormScreen(category: cat)),
    );
    if (result != null && mounted) {
      setState(() {
        if (cat != null) {
          final idx = _categories.indexOf(cat);
          _categories[idx] = result;
        } else {
          _categories.add(result);
        }
      });
    }
  }

  void _view(SupplyProductCategory cat) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SupplyProductCategoryDetailScreen(category: cat)),
    );
  }

  void _delete(SupplyProductCategory cat) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Delete "${cat.productName}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() => _categories.remove(cat));
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Product Category'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _categories.isEmpty
          ? const Center(child: Text('No categories added yet', style: TextStyle(color: Colors.black54)))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
              itemCount: _categories.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) return _buildHeader();
                final cat = _categories[i - 1];
                final isLast = i == _categories.length;
                return _buildSlidableRow(cat, isLast);
              },
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: const Row(
        children: [
          Expanded(child: Text('Product Name', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
        ],
      ),
    );
  }

  Widget _buildSlidableRow(SupplyProductCategory cat, bool isLast) {
    return ClipRRect(
      borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(16)) : BorderRadius.zero,
      child: Slidable(
        key: ValueKey(cat.productName),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _view(cat),
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              icon: Icons.visibility,
              label: 'View',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _openForm(cat),
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (_) => _delete(cat),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                if (cat.productImage != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(cat.productImage!, width: 32, height: 32, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 32, color: Color(0xFF64748B))),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(child: Text(cat.productName)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
