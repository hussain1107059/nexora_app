import 'package:flutter/material.dart';

import '../models/access_role.dart';
import '../models/erp_module.dart';

class AccessRoleFormScreen extends StatefulWidget {
  final AccessRole? role;

  const AccessRoleFormScreen({super.key, this.role});

  @override
  State<AccessRoleFormScreen> createState() => _AccessRoleFormScreenState();
}

class _AccessRoleFormScreenState extends State<AccessRoleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late String _status;
  late Map<String, String> _permissions;

  static const _statuses = ['Active', 'Inactive'];
  static const _accessOptions = ['See', 'Add', 'Edit', 'Delete', 'All'];

  @override
  void initState() {
    super.initState();
    final r = widget.role;
    _nameCtrl = TextEditingController(text: r?.roleName ?? '');
    _descCtrl = TextEditingController(text: r?.description ?? '');
    _status = r?.status ?? _statuses.first;

    _permissions = {};
    for (final m in erpModules) {
      final existing = r?.permissions.where((p) => p.moduleName == m.title).firstOrNull;
      _permissions[m.title] = existing?.access ?? 'See';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final perms = _permissions.entries
        .map((e) => ModulePermission(moduleName: e.key, access: e.value))
        .toList();
    final role = AccessRole(
      roleName: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      status: _status,
      permissions: perms,
    );
    Navigator.pop(context, role);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.role != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Access Role' : 'Add Access Role'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildField('Role Name', _nameCtrl, required: true),
              const SizedBox(height: 14),
              _buildField('Description', _descCtrl, maxLines: 3),
              const SizedBox(height: 14),
              _buildDropdown('Status', _status, _statuses, (v) {
                if (v != null) setState(() => _status = v);
              }),
              const SizedBox(height: 20),
              const Text('Module Permissions',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF19243A))),
              const SizedBox(height: 12),
              ...erpModules.map((m) => _buildPermissionRow(m.title, _permissions[m.title]!)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionRow(String moduleName, String currentAccess) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(moduleName,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF19243A))),
          ),
          SizedBox(
            width: 140,
            child: DropdownButtonFormField<String>(
              key: ValueKey('${moduleName}_$currentAccess'),
              initialValue: currentAccess,
              items: _accessOptions
                  .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis)))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  setState(() => _permissions[moduleName] = v);
                }
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl,
      {bool required = false, int maxLines = 1}) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: required
          ? (v) =>
              (v == null || v.trim().isEmpty) ? '$label is required' : null
          : null,
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items,
      ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      key: ValueKey('${label}_$value'),
      initialValue: value,
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
