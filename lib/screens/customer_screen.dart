import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/organization.dart';
import '../widgets/erp_drawer.dart';
import 'organization_detail_screen.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  static const List<Organization> _customers = [
    Organization(
      name: 'Green Agro', owner: 'Md. Rahim', phone: '+8801712345680', balance: 45000,
      transactions: [
        OrgTransaction(date: '2026-07-01', type: 'Sale', total: 15000, paid: 10000, due: 5000),
        OrgTransaction(date: '2026-07-05', type: 'Sale', total: 20000, paid: 15000, due: 5000),
        OrgTransaction(date: '2026-07-10', type: 'Sale Return', total: 3000, paid: 3000, due: 0),
      ],
    ),
    Organization(
      name: 'Rahim Traders', owner: 'Abdur Rahim', phone: '+8801712345681', balance: 32000,
      transactions: [
        OrgTransaction(date: '2026-07-03', type: 'Sale', total: 18000, paid: 12000, due: 6000),
        OrgTransaction(date: '2026-07-08', type: 'Sale Return', total: 2000, paid: 2000, due: 0),
      ],
    ),
    Organization(
      name: 'Hasan Enterprise', owner: 'Hasan Ali', phone: '+8801712345682', balance: 55000,
      transactions: [
        OrgTransaction(date: '2026-07-02', type: 'Sale', total: 25000, paid: 15000, due: 10000),
        OrgTransaction(date: '2026-07-09', type: 'Sale', total: 30000, paid: 20000, due: 10000),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Customer'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      drawer: const ERPDrawer(currentRoute: '/customer'),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        itemCount: _customers.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) return _buildHeader();
          final c = _customers[i - 1];
          final isLast = i == _customers.length;
          return _buildSlidableRow(context, c, isLast);
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

  Widget _buildSlidableRow(BuildContext context, Organization c, bool isLast) {
    return ClipRRect(
      borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(16)) : BorderRadius.zero,
      child: Slidable(
        key: ValueKey(c.phone),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _makeCall(c.phone),
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
                MaterialPageRoute(builder: (_) => OrganizationDetailScreen(title: 'Customer', org: c)),
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
                Expanded(flex: 3, child: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w500))),
                Expanded(flex: 2, child: Text(c.owner, textAlign: TextAlign.center)),
                Expanded(flex: 2, child: Text(c.balance.toStringAsFixed(2), textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w600))),
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
