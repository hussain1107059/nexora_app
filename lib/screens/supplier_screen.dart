import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/organization.dart';
import '../widgets/erp_drawer.dart';
import 'organization_detail_screen.dart';

class SupplierScreen extends StatelessWidget {
  const SupplierScreen({super.key});

  static const List<Organization> _suppliers = [
    Organization(
      name: 'Sonali Suppliers', owner: 'Karim Uddin', phone: '+8801712345690', balance: 25000,
      transactions: [
        OrgTransaction(date: '2026-07-02', type: 'Supply', total: 12000, paid: 8000, due: 4000),
        OrgTransaction(date: '2026-07-07', type: 'Supply', total: 15000, paid: 10000, due: 5000),
      ],
    ),
    Organization(
      name: 'Alim Store', owner: 'Alim Hossain', phone: '+8801712345691', balance: 18000,
      transactions: [
        OrgTransaction(date: '2026-07-04', type: 'Supply', total: 10000, paid: 6000, due: 4000),
        OrgTransaction(date: '2026-07-11', type: 'Supply Return', total: 2000, paid: 2000, due: 0),
      ],
    ),
    Organization(
      name: 'Karim Brothers', owner: 'Karim Hasan', phone: '+8801712345692', balance: 35000,
      transactions: [
        OrgTransaction(date: '2026-07-01', type: 'Supply', total: 20000, paid: 12000, due: 8000),
        OrgTransaction(date: '2026-07-09', type: 'Supply', total: 18000, paid: 10000, due: 8000),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Supplier'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      drawer: const ERPDrawer(currentRoute: '/supplier'),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        itemCount: _suppliers.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) return _buildHeader();
          final s = _suppliers[i - 1];
          final isLast = i == _suppliers.length;
          return _buildSlidableRow(context, s, isLast);
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: const Row(
        children: [
          Expanded(flex: 3, child: Text('Organization', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 2, child: Text('Owner', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)), textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text('Balance', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)), textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Widget _buildSlidableRow(BuildContext context, Organization s, bool isLast) {
    return ClipRRect(
      borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(16)) : BorderRadius.zero,
      child: Slidable(
        key: ValueKey(s.phone),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _makeCall(s.phone),
              backgroundColor: const Color(0xFF22C55E),
              foregroundColor: Colors.white,
              icon: Icons.phone,
              label: 'Call',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => OrganizationDetailScreen(title: 'Supplier', org: s)),
              ),
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              icon: Icons.visibility,
              label: 'View',
            ),
          ],
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text(s.name, style: const TextStyle(fontWeight: FontWeight.w500))),
                Expanded(flex: 2, child: Text(s.owner, textAlign: TextAlign.center)),
                Expanded(flex: 2, child: Text(s.balance.toStringAsFixed(2), textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w600))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _makeCall(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
