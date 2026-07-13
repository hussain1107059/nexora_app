import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/employee.dart';
import '../widgets/erp_drawer.dart';

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({super.key});

  static const List<Employee> _employees = [
    Employee(name: 'Mir Hussain Kabir', designation: 'CEO', phone: '+8801712345678'),
    Employee(name: 'Rahim Uddin', designation: 'Manager', phone: '+8801712345679'),
    Employee(name: 'Karim Hasan', designation: 'Accountant', phone: '+8801712345680'),
    Employee(name: 'Fatima Begum', designation: 'Sales Executive', phone: '+8801712345681'),
    Employee(name: 'Jahidul Islam', designation: 'Supply Officer', phone: '+8801712345682'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Employee'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      drawer: const ERPDrawer(currentRoute: '/employee'),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        itemCount: _employees.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) return _buildHeader();
          final emp = _employees[i - 1];
          final isLast = i == _employees.length;
          return _buildSlidableRow(context, emp, isLast);
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
          Expanded(flex: 3, child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 3, child: Text('Designation', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)), textAlign: TextAlign.center)),
          Expanded(flex: 3, child: Text('Phone', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)), textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Widget _buildSlidableRow(BuildContext context, Employee emp, bool isLast) {
    return ClipRRect(
      borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(16)) : BorderRadius.zero,
      child: Slidable(
        key: ValueKey(emp.phone),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _makeCall(emp.phone),
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
              onPressed: (_) => _openWhatsApp(emp.phone),
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
              icon: Icons.chat,
              label: 'WhatsApp',
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
                Expanded(flex: 3, child: Text(emp.name, style: const TextStyle(fontWeight: FontWeight.w500))),
                Expanded(flex: 3, child: Text(emp.designation, textAlign: TextAlign.center)),
                Expanded(flex: 3, child: Text(emp.phone, textAlign: TextAlign.right)),
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

  void _openWhatsApp(String phone) async {
    final uri = Uri.parse('https://wa.me/${phone.replaceAll(RegExp(r'[^0-9]'), '')}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
