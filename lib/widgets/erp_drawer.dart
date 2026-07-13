import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../models/erp_module.dart';
import '../utils/app_routes.dart';

class ERPDrawer extends StatelessWidget {
  final String currentRoute;

  const ERPDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FBFF), Color(0xFFEAF3FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFFBFDBFE), Color(0xFF93C5FD)]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/nexora1.jpg', width: 80, height: 80, fit: BoxFit.contain),
                  const SizedBox(height: 14),
                  const Text('NexoraERP', style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('Mir Hussain Kabir', style: TextStyle(color: Colors.black87, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _drawerItem(context, icon: Icons.dashboard_outlined, title: 'Dashboard', selected: currentRoute == AppRoutes.dashboard, route: AppRoutes.dashboard, iconColor: const Color(0xFF1E40AF), bgColor: const Color(0xFF1E40AF).withOpacity(0.15)),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Text('Modules', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1E3A8A))),
            ),
            ...erpModules.map((m) => _moduleItem(context, m)),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Text('Language', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1E3A8A))),
            ),
            RadioListTile<AppLanguage>(
              title: Text(loc.englishLabel),
              value: AppLanguage.english,
              groupValue: loc.language,
              activeColor: const Color(0xFF2563EB),
              onChanged: (value) {
                if (value != null) {
                  loc.setLanguage(value);
                }
              },
            ),
            RadioListTile<AppLanguage>(
              title: Text(loc.banglaLabel),
              value: AppLanguage.bangla,
              groupValue: loc.language,
              activeColor: const Color(0xFF2563EB),
              onChanged: (value) {
                if (value != null) {
                  loc.setLanguage(value);
                }
              },
            ),
            const SizedBox(height: 8),
            _drawerItem(context, icon: Icons.logout, title: loc.signOut, selected: false, route: AppRoutes.login, iconColor: Colors.red, textColor: Colors.red),
            const SizedBox(height: 8),
            const Divider(indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: ListTile(
                leading: Image.asset('assets/images/company_logo.jpeg', width: 28, height: 28, fit: BoxFit.contain),
                title: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFFEC4899)]).createShader(bounds),
                  child: const Text('BadhonByte', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                subtitle: const Text('Technology Partner', style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF64748B))),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(BuildContext context, {required IconData icon, required String title, required bool selected, required String route, Color? iconColor, Color? textColor, Color? bgColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: bgColor ?? (selected ? const Color(0xFFDDEAFE) : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor ?? (selected ? const Color(0xFF2563EB) : const Color(0xFF475569)), size: 20),
        ),
        title: Text(title, style: TextStyle(fontWeight: selected ? FontWeight.w700 : FontWeight.w500, color: textColor ?? (selected ? const Color(0xFF1E3A8A) : const Color(0xFF334155)))),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        tileColor: selected ? const Color(0xFFDDEAFE) : Colors.transparent,
        onTap: () => Navigator.pushReplacementNamed(context, route),
      ),
    );
  }

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
      case 'check_circle':
        return Icons.check_circle_outlined;
      default:
        return Icons.widgets_outlined;
    }
  }

  static const List<Color> _iconColors = [
    Color(0xFF1E40AF),
    Color(0xFFB91C1C),
    Color(0xFF047857),
    Color(0xFFD97706),
    Color(0xFF7C3AED),
    Color(0xFFDB2777),
    Color(0xFF0284C7),
    Color(0xFFEA580C),
    Color(0xFF0891B2),
    Color(0xFF4F46E5),
    Color(0xFF16A34A),
    Color(0xFF9333EA),
  ];

  int _colorIndex(String moduleName) {
    final hash = moduleName.hashCode;
    return hash.abs() % _iconColors.length;
  }

  Widget _moduleItem(BuildContext context, ErpModule module) {
    final color = _iconColors[_colorIndex(module.title)];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(_iconForModule(module.icon), color: color, size: 20),
        ),
        title: Text(module.title, style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF334155))),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        onTap: () => Navigator.pushNamed(context, AppRoutes.module, arguments: module),
      ),
    );
  }
}
