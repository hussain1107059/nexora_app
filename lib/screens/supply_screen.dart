import 'package:flutter/material.dart';

import 'supply_product_category_screen.dart';
import 'supply_product_screen.dart';

class SupplyScreen extends StatelessWidget {
  const SupplyScreen({super.key});

  static const List<Color> _iconColors = [
    Color(0xFFD97706),
    Color(0xFF16A34A),
  ];

  static const List<Map<String, dynamic>> _supplyItems = [
    {'title': 'Product Category', 'icon': Icons.category_outlined},
    {'title': 'Supply Product', 'icon': Icons.local_shipping_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Supply'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _supplyItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            final item = _supplyItems[index];
            final iconColor = _iconColors[index % _iconColors.length];
            return InkWell(
              onTap: () {
                final title = item['title'] as String;
                if (title == 'Product Category') {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SupplyProductCategoryScreen()));
                } else if (title == 'Supply Product') {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SupplyProductScreen()));
                }
              },
              borderRadius: BorderRadius.circular(22),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 6))],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item['icon'] as IconData, color: iconColor, size: 18),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['title'] as String,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
