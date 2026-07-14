import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/authorization.dart';
import 'authorization_detail_screen.dart';
import 'authorization_form_screen.dart';

class AuthorizationScreen extends StatefulWidget {
  const AuthorizationScreen({super.key});

  @override
  State<AuthorizationScreen> createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {
  List<Authorization> _data = [
    const Authorization(user: 'Admin', accessType: 'Full Access', userName: 'admin', password: 'admin123', status: 'Active'),
    const Authorization(user: 'Manager', accessType: 'Limited', userName: 'manager1', password: 'pass456', status: 'Active'),
    const Authorization(user: 'Viewer', accessType: 'Read Only', userName: 'viewer1', password: 'view789', status: 'Inactive'),
  ];

  void _openForm([Authorization? auth]) {
    Navigator.push<Authorization>(
      context,
      MaterialPageRoute(builder: (_) => AuthorizationFormScreen(authorization: auth)),
    ).then((result) {
      if (result != null) {
        setState(() {
          if (auth != null) {
            final index = _data.indexOf(auth);
            if (index >= 0) _data[index] = result;
          } else {
            _data.insert(0, result);
          }
        });
      }
    });
  }

  void _view(Authorization auth) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AuthorizationDetailScreen(authorization: auth)),
    );
  }

  void _delete(Authorization auth) {
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
              setState(() => _data.remove(auth));
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
        title: const Text('Authorization'),
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
          final auth = _data[index - 1];
          return _buildSlidableRow(auth, index == _data.length);
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
          Expanded(flex: 3, child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
          Expanded(flex: 3, child: Text('Access', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
        ],
      ),
    );
  }

  Widget _buildSlidableRow(Authorization auth, bool isLast) {
    return ClipRRect(
      borderRadius: isLast ? BorderRadius.circular(10) : BorderRadius.zero,
      child: Slidable(
        key: ValueKey(auth.hashCode),
        startActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _view(auth),
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
              onPressed: (_) => _openForm(auth),
              backgroundColor: const Color(0xFFD97706),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (_) => _delete(auth),
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
            onTap: () => _openForm(auth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Text(auth.name, style: const TextStyle(fontSize: 12))),
                  Expanded(flex: 3, child: Text(auth.accessType, style: const TextStyle(fontSize: 12))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
