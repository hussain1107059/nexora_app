import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../models/erp_module.dart';
import '../widgets/erp_drawer.dart';
import 'bank_screen.dart';
import 'bank_balance_screen.dart';
import 'bank_transfer_screen.dart';
import 'hatchery_expenditure_screen.dart';
import 'hatchery_income_screen.dart';
import 'other_income_screen.dart';
import 'payment_screen.dart';
import 'product_category_screen.dart';
import 'product_screen.dart';
import 'withdrawal_screen.dart';

class ModuleScreen extends StatefulWidget {
  const ModuleScreen({super.key});

  @override
  State<ModuleScreen> createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  String? _subTitle;
  List<Map<String, dynamic>>? _subItems;

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

  static const List<Map<String, dynamic>> _accountItems = [
    {'title': 'Bank', 'icon': Icons.account_balance_outlined},
    {'title': 'Bank Transfer', 'icon': Icons.swap_horiz_outlined},
    {'title': 'Bank Balance', 'icon': Icons.monetization_on_outlined},
    {'title': 'Payment', 'icon': Icons.payment_outlined},
    {'title': 'Other Income', 'icon': Icons.add_circle_outlined},
    {'title': 'Hatchery', 'icon': Icons.egg_outlined},
    {'title': 'Withdrawal', 'icon': Icons.money_off_outlined},
  ];

  static const List<Map<String, dynamic>> _adminItems = [
    {'title': 'Authorization', 'icon': Icons.verified_user_outlined},
    {'title': 'Record Change Approval', 'icon': Icons.edit_note_outlined},
    {'title': 'Access Role', 'icon': Icons.admin_panel_settings_outlined},
  ];

  static const List<Map<String, dynamic>> _productItems = [
    {'title': 'Product Category', 'icon': Icons.category_outlined},
    {'title': 'Products', 'icon': Icons.inventory_outlined},
  ];

  static const List<Map<String, dynamic>> _manufactureItems = [
    {'title': 'Production', 'icon': Icons.precision_manufacturing_outlined},
    {'title': 'Product Stock Entry', 'icon': Icons.inventory_outlined},
  ];

  static const List<Map<String, dynamic>> _stockItems = [
    {'title': 'Product Stock', 'icon': Icons.inventory_outlined},
    {'title': 'Supply Stock', 'icon': Icons.local_shipping_outlined},
  ];

  static const List<Map<String, dynamic>> _reportItems = [
    {'title': 'Sale', 'icon': Icons.shopping_cart_outlined},
    {'title': 'Sale Return', 'icon': Icons.assignment_return_outlined},
    {'title': 'Payment', 'icon': Icons.payment_outlined},
    {'title': 'Expenditure', 'icon': Icons.receipt_outlined},
    {'title': 'Other Income', 'icon': Icons.add_circle_outlined},
    {'title': 'Statement', 'icon': Icons.description_outlined},
    {'title': 'Supply', 'icon': Icons.local_shipping_outlined},
    {'title': 'Hatchery', 'icon': Icons.egg_outlined},
    {'title': 'Sale Register', 'icon': Icons.receipt_long_outlined},
    {'title': 'Supply & Expense', 'icon': Icons.compare_arrows_outlined},
    {'title': 'Loan Interest', 'icon': Icons.percent_outlined},
  ];

  static const _hatcheryItems = [
    {'title': 'Income', 'icon': Icons.trending_up_outlined},
    {'title': 'Expenditure', 'icon': Icons.trending_down_outlined},
  ];

  void _openSubGrid(String title, List<Map<String, dynamic>> items) {
    setState(() {
      _subTitle = title;
      _subItems = items;
    });
  }

  void _goBack() {
    setState(() {
      _subTitle = null;
      _subItems = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final module = ModalRoute.of(context)?.settings.arguments as ErpModule?;
    final loc = AppLocalizations.of(context);
    final isAccount = module?.title == 'Account';
    final isAdmin = module?.title == 'Administration';
    final isProduct = module?.title == 'Product';
    final isManufacture = module?.title == 'Manufacture';
    final isStock = module?.title == 'Stock';
    final isReport = module?.title == 'Report';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(_subTitle ?? module?.title ?? loc.modulesTitle),
        centerTitle: true,
        leading: _subTitle != null
            ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: _goBack)
            : null,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      drawer: _subTitle == null ? const ERPDrawer(currentRoute: '/module') : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: isAccount
            ? (_subItems != null ? _buildSubGrid() : _buildAccountGrid())
            : isAdmin
                ? _buildAdminGrid()
                : isProduct
                    ? _buildProductGrid()
                    : isManufacture
                        ? _buildManufactureGrid()
                        : isStock
                            ? _buildStockGrid()
                            : isReport
                                ? _buildReportGrid()
                                : _buildDefaultView(module, loc),
      ),
    );
  }

  Widget _buildAccountGrid() {
    return _buildGenericGrid(_accountItems);
  }

  Widget _buildAdminGrid() {
    return _buildGenericGrid(_adminItems);
  }

  Widget _buildProductGrid() {
    return _buildGenericGrid(_productItems);
  }

  Widget _buildManufactureGrid() {
    return _buildGenericGrid(_manufactureItems);
  }

  Widget _buildStockGrid() {
    return _buildGenericGrid(_stockItems);
  }

  Widget _buildReportGrid() {
    return _buildGenericGrid(_reportItems);
  }

  Widget _buildGenericGrid(List<Map<String, dynamic>> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        final iconColor = _iconColors[index % _iconColors.length];
        return InkWell(
          onTap: () {
            final title = item['title'] as String;
            if (items == _accountItems) {
              if (title == 'Hatchery') {
                _openSubGrid('Hatchery', _hatcheryItems);
              } else if (title == 'Bank') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const BankScreen()));
              } else if (title == 'Bank Transfer') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const BankTransferScreen()));
              } else if (title == 'Bank Balance') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const BankBalanceScreen()));
              } else if (title == 'Payment') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentScreen()));
              } else if (title == 'Other Income') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const OtherIncomeScreen()));
              } else if (title == 'Withdrawal') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const WithdrawalScreen()));
              }
            } else if (items == _productItems) {
              if (title == 'Product Category') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductCategoryScreen()));
              } else if (title == 'Products') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductScreen()));
              }
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
                Text(item['title'] as String, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _subItems!.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            final item = _subItems![index];
            final iconColor = _iconColors[index % _iconColors.length];
            return InkWell(
              onTap: () {
                final title = item['title'] as String;
                if (_subTitle == 'Hatchery') {
                  if (title == 'Income') {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const HatcheryIncomeScreen()));
                  } else if (title == 'Expenditure') {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const HatcheryExpenditureScreen()));
                  }
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
                    Text(item['title'] as String, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDefaultView(ErpModule? module, AppLocalizations loc) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF2563EB)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.layers_outlined, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 16),
              Text(module?.title ?? loc.modulesTitle, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(module?.description ?? loc.drawerSubtitle, style: TextStyle(color: Colors.white.withOpacity(0.88), fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _infoCard(title: 'Overview', value: 'Manage all core operations from one place.'),
        const SizedBox(height: 12),
        _infoCard(title: 'Status', value: 'Healthy • 12 updates today'),
        const SizedBox(height: 12),
        _infoCard(title: 'Action', value: 'Open, review, and complete tasks quickly.'),
      ],
    );
  }

  Widget _infoCard({required String title, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A))),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(color: Colors.black54, fontSize: 13)),
        ],
      ),
    );
  }
}