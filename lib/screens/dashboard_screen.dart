import 'package:flutter/material.dart';

import '../models/erp_module.dart';
import '../widgets/dashboard_chart.dart';
import '../widgets/erp_drawer.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  IconData _iconForModule(String name) {
    switch (name) {
      case 'account_balance':
        return Icons.account_balance_outlined;
      case 'shopping_cart':
        return Icons.shopping_cart_outlined;
      case 'admin_panel_settings':
        return Icons.admin_panel_settings_outlined;
      case 'local_shipping':
        return Icons.local_shipping_outlined;
      case 'inventory_2':
        return Icons.inventory_2_outlined;
      case 'analytics':
        return Icons.analytics_outlined;
      case 'build_circle':
        return Icons.build_circle_outlined;
      case 'receipt':
        return Icons.receipt_outlined;
      case 'inventory':
        return Icons.inventory_outlined;
      case 'assignment_return':
        return Icons.assignment_return_outlined;
      case 'precision_manufacturing':
        return Icons.precision_manufacturing_outlined;
      case 'report_problem':
        return Icons.report_problem_outlined;
      default:
        return Icons.widgets_outlined;
    }
  }

  static const List<Color> _iconColors = [
    Color(0xFF1E40AF), // Accounts - deep blue
    Color(0xFFB91C1C), // Administration - deep red
    Color(0xFF047857), // Product - deep emerald
    Color(0xFFD97706), // Supply - deep amber
    Color(0xFF7C3AED), // Manufacture - deep violet
    Color(0xFFDB2777), // Sale - deep pink
    Color(0xFF0284C7), // Work Order - deep sky
    Color(0xFFEA580C), // Expenditure - deep orange
    Color(0xFF0891B2), // Sale Return - deep cyan
    Color(0xFF4F46E5), // Inventory Loss - deep indigo
    Color(0xFF16A34A), // Report - deep green
    Color(0xFF9333EA), // Stock - deep purple
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(colors: [Color(0xFF0EA5E9), Color(0xFF0284C7), Color(0xFF0369A1)]).createShader(bounds),
          child: const Text('NexoraERP', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      drawer: const ERPDrawer(currentRoute: '/dashboard'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DashboardChart(),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: erpModules.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.95,
              ),
              itemBuilder: (context, index) {
                final module = erpModules[index];
                final iconColor = _iconColors[index % _iconColors.length];
                return InkWell(
                  onTap: () => Navigator.pushNamed(context, '/module', arguments: module),
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
                          child: Icon(_iconForModule(module.icon), color: iconColor, size: 18),
                        ),
                        const SizedBox(height: 6),
                        Text(module.title, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
