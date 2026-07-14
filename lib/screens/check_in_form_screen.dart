import 'package:flutter/material.dart';

import '../models/check_in.dart';
import '../services/location_service.dart';

class CheckInFormScreen extends StatefulWidget {
  final CheckInSession? session;

  const CheckInFormScreen({super.key, this.session});

  @override
  State<CheckInFormScreen> createState() => _CheckInFormScreenState();
}

class _CheckInFormScreenState extends State<CheckInFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _remarksCtrl;
  late DateTime _date;
  late List<CheckInPunch> _punches;
  bool _isPunching = false;

  @override
  void initState() {
    super.initState();
    final s = widget.session;
    _titleCtrl = TextEditingController(text: s?.title ?? '');
    _remarksCtrl = TextEditingController(text: s?.remarks ?? '');
    _date = s?.date ?? DateTime.now();
    _punches = s?.punches != null ? List.from(s!.punches) : [];
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _remarksCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _punchIn() async {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter title first')),
      );
      return;
    }

    setState(() => _isPunching = true);

    final location = await LocationService.getCurrentLocation();

    if (location == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not get location. Check GPS is on.')),
      );
      setState(() => _isPunching = false);
      return;
    }

    final punch = CheckInPunch(
      time: DateTime.now(),
      latitude: location.latitude,
      longitude: location.longitude,
      address: location.address,
    );

    setState(() {
      _punches.add(punch);
      _isPunching = false;
    });

    _showPunchEditDialog(punch, _punches.length - 1);
  }

  void _showPunchEditDialog(CheckInPunch punch, int index) {
    final descCtrl = TextEditingController(text: punch.description);
    final amtCtrl = TextEditingController(
      text: punch.amount > 0 ? punch.amount.toString() : '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(punch.address,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(
              '${punch.latitude.toStringAsFixed(4)}, ${punch.longitude.toStringAsFixed(4)}',
              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descCtrl,
              decoration: InputDecoration(
                labelText: 'Description',
                filled: true,
                fillColor: const Color(0xFFF4F7FB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amtCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount (\$)',
                filled: true,
                fillColor: const Color(0xFFF4F7FB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Skip', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            onPressed: () {
              final updated = punch.copyWith(
                description: descCtrl.text.trim(),
                amount: double.tryParse(amtCtrl.text) ?? 0,
              );
              setState(() => _punches[index] = updated);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editPunch(int index) {
    _showPunchEditDialog(_punches[index], index);
  }

  void _deletePunch(int index) {
    setState(() => _punches.removeAt(index));
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_punches.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please punch in at least once')),
      );
      return;
    }
    final session = CheckInSession(
      date: _date,
      title: _titleCtrl.text.trim(),
      remarks: _remarksCtrl.text.trim(),
      punches: List.from(_punches),
    );
    Navigator.pop(context, session);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.session != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Check In' : 'Add Check In'),
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
              _buildDateField(),
              const SizedBox(height: 14),
              _buildField('Title', _titleCtrl, required: true),
              const SizedBox(height: 14),
              _buildField('Remarks', _remarksCtrl, maxLines: 2),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Location Punches',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF19243A))),
                  SizedBox(
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: _isPunching ? null : _punchIn,
                      icon: _isPunching
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.gps_fixed, size: 18),
                      label: Text(_isPunching ? 'Punching...' : 'Punch In'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_punches.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEEEEEE)),
                  ),
                  child: const Center(
                    child: Text(
                      'No punches yet. Tap "Punch In" to capture location.',
                      style: TextStyle(
                          color: Color(0xFF64748B), fontSize: 13),
                    ),
                  ),
                )
              else
                _buildPunchesTable(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPunchesTable() {
    final totalAmt = _punches.fold(0.0, (s, p) => s + p.amount);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: const Row(
              children: [
                Expanded(flex: 2, child: Text('Time',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Color(0xFF19243A)))),
                Expanded(flex: 3, child: Text('Location',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Color(0xFF19243A)))),
                Expanded(flex: 2, child: Text('Description',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Color(0xFF19243A)))),
                Expanded(flex: 1, child: Text('Amt',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Color(0xFF19243A)))),
                SizedBox(width: 50),
              ],
            ),
          ),
          ...List.generate(_punches.length, (index) {
            final punch = _punches.reversed.toList()[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(_formatTime(punch.time),
                        style: const TextStyle(fontSize: 11)),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(punch.address,
                            style: const TextStyle(fontSize: 11),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      punch.description.isNotEmpty
                          ? punch.description
                          : '—',
                      style: TextStyle(
                        fontSize: 11,
                        color: punch.description.isNotEmpty
                            ? Colors.black87
                            : const Color(0xFFCBD5E1),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      punch.amount > 0 ? '\$${punch.amount.toStringAsFixed(0)}' : '—',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: punch.amount > 0
                            ? Colors.black87
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit,
                              size: 16, color: Color(0xFF2563EB)),
                          onPressed: () => _editPunch(index),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                              minWidth: 24, minHeight: 24),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              size: 16, color: Colors.red),
                          onPressed: () => _deletePunch(index),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                              minWidth: 24, minHeight: 24),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Spacer(),
                Text(
                  'Total: \$${totalAmt.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF19243A)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: _pickDate,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_formatDate(_date)),
            const Icon(Icons.calendar_today,
                size: 18, color: Color(0xFF64748B)),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl,
      {TextInputType? keyboardType,
      bool required = false,
      int maxLines = 1}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: required
          ? (v) =>
              (v == null || v.trim().isEmpty) ? '$label is required' : null
          : null,
    );
  }
}
