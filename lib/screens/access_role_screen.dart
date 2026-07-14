import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/access_role.dart';
import 'access_role_detail_screen.dart';
import 'access_role_form_screen.dart';

class AccessRoleScreen extends StatefulWidget {
  const AccessRoleScreen({super.key});

  @override
  State<AccessRoleScreen> createState() => _AccessRoleScreenState();
}

class _AccessRoleScreenState extends State<AccessRoleScreen> {
  List<AccessRole> _data = [
    const AccessRole(roleName: 'Super Admin', description: 'Full system access', status: 'Active', permissions: []),
    const AccessRole(roleName: 'Manager', description: 'Can manage operations', status: 'Active', permissions: []),
    const AccessRole(roleName: 'Operator', description: 'Basic data entry', status: 'Inactive', permissions: []),
  ];

  void _openForm([AccessRole? role]) {
    Navigator.push<AccessRole>(
      context,
      MaterialPageRoute(builder: (_) => AccessRoleFormScreen(role: role)),
    ).then((result) {
      if (result != null) {
        setState(() {
          if (role != null) {
            final index = _data.indexOf(role);
            if (index >= 0) _data[index] = result;
          } else {
            _data.insert(0, result);
          }
        });
      }
    });
  }

  void _view(AccessRole role) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AccessRoleDetailScreen(role: role)),
    );
  }

  void _delete(AccessRole role) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete'),
        content: const Text('Are you sure you want to delete this record?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _data.remove(role));
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
        title: const Text('Access Role'),
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
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
        itemCount: _data.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) return _buildHeader();
          final role = _data[index - 1];
          return _buildSlidableRow(role, index == _data.length);
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Expanded(flex: 3, child: Text('Role Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
          Expanded(flex: 2, child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
        ],
      ),
    );
  }

  Widget _buildSlidableRow(AccessRole role, bool isLast) {
    return ClipRRect(
      borderRadius: isLast ? BorderRadius.circular(10) : BorderRadius.zero,
      child: Slidable(
        key: ValueKey(role.hashCode),
        startActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _view(role),
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              icon: Icons.visibility,
              label: 'View',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _openForm(role),
              backgroundColor: const Color(0xFFD97706),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (_) => _delete(role),
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
          child: InkWell(
            onTap: () => _openForm(role),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Text(role.roleName, style: const TextStyle(fontSize: 12))),
                  Expanded(flex: 2, child: Text(role.status, style: const TextStyle(fontSize: 12))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
