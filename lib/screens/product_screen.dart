import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/product_item.dart';
import 'product_detail_screen.dart';
import 'product_form_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final List<ProductItem> _products = [
    const ProductItem(category: 'Broiler Feed', name: 'Starter Feed', package: 'Bag (50 kg)', price: 2500),
    const ProductItem(category: 'Layer Feed', name: 'Layer Pellet', package: 'Bag (40 kg)', price: 2200),
    const ProductItem(category: 'Medicine', name: 'Vitamin Mix', package: 'Box (100 pcs)', price: 850),
    const ProductItem(category: 'Supplement', name: 'Calcium Plus', package: 'Packet (1 kg)', price: 450),
    const ProductItem(category: 'Broiler Feed', name: 'Finisher Feed', package: 'Bag (50 kg)', price: 2400),
  ];

  void _openForm([ProductItem? product]) async {
    final result = await Navigator.push<ProductItem>(
      context,
      MaterialPageRoute(builder: (_) => ProductFormScreen(product: product)),
    );
    if (result != null && mounted) {
      setState(() {
        if (product != null) {
          final idx = _products.indexOf(product);
          _products[idx] = result;
        } else {
          _products.add(result);
        }
      });
    }
  }

  void _view(ProductItem product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
    );
  }

  void _delete(ProductItem product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Delete "${product.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() => _products.remove(product));
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
        title: const Text('Products'),
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
      body: _products.isEmpty
          ? const Center(child: Text('No products added yet', style: TextStyle(color: Colors.black54)))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
              itemCount: _products.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) return _buildHeader();
                final product = _products[i - 1];
                final isLast = i == _products.length;
                return _buildSlidableRow(product, isLast);
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
          Expanded(flex: 2, child: Text('Product', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 1, child: Text('Package', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A))),
          ),
          Expanded(flex: 1, child: Text('Price', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A))),
          ),
        ],
      ),
    );
  }

  Widget _buildSlidableRow(ProductItem product, bool isLast) {
    return ClipRRect(
      borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(16)) : BorderRadius.zero,
      child: Slidable(
        key: ValueKey(product.name),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _view(product),
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
              onPressed: (_) => _openForm(product),
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (_) => _delete(product),
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
                Expanded(flex: 2, child: Text(product.name)),
                Expanded(flex: 1, child: Text(product.package)),
                Expanded(flex: 1, child: Text('৳${product.price.toStringAsFixed(0)}')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
