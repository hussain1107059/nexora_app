import 'package:flutter/material.dart';

import '../models/authorization.dart';

class AuthorizationFormScreen extends StatefulWidget {
  final Authorization? authorization;

  const AuthorizationFormScreen({super.key, this.authorization});

  @override
  State<AuthorizationFormScreen> createState() => _AuthorizationFormScreenState();
}

class _AuthorizationFormScreenState extends State<AuthorizationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _userNameCtrl;
  late final TextEditingController _passwordCtrl;
  late String _user;
  late String _accessType;
  late String _status;

  static const _users = ['Admin', 'Manager', 'Operator', 'Viewer'];
  static const _accessTypes = ['Full Access', 'Read Only', 'Limited', 'Custom'];
  static const _statuses = ['Active', 'Inactive'];

  @override
  void initState() {
    super.initState();
    final a = widget.authorization;
    _userNameCtrl = TextEditingController(text: a?.userName ?? '');
    _passwordCtrl = TextEditingController(text: a?.password ?? '');
    _user = a?.user ?? _users.first;
    _accessType = a?.accessType ?? _accessTypes.first;
    _status = a?.status ?? _statuses.first;
  }

  @override
  void dispose() {
    _userNameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final auth = Authorization(
      user: _user,
      accessType: _accessType,
      userName: _userNameCtrl.text.trim(),
      password: _passwordCtrl.text.trim(),
      status: _status,
    );
    Navigator.pop(context, auth);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.authorization != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Authorization' : 'Add Authorization'),
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
              _buildDropdown('User', _user, _users, (v) {
                if (v != null) setState(() => _user = v);
              }),
              const SizedBox(height: 14),
              _buildDropdown('Access Type', _accessType, _accessTypes, (v) {
                if (v != null) setState(() => _accessType = v);
              }),
              const SizedBox(height: 14),
              _buildField('User Name', _userNameCtrl),
              const SizedBox(height: 14),
              _buildField('Password', _passwordCtrl, obscureText: true),
              const SizedBox(height: 14),
              _buildDropdown('Status', _status, _statuses, (v) {
                if (v != null) setState(() => _status = v);
              }),
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

  Widget _buildField(String label, TextEditingController ctrl, {bool obscureText = false}) {
    return TextFormField(
      controller: ctrl,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      key: ValueKey('${label}_$value'),
      initialValue: value,
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
