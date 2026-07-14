import 'package:flutter/material.dart';

import '../models/authorization.dart';

class AuthorizationDetailScreen extends StatelessWidget {
  final Authorization authorization;

  const AuthorizationDetailScreen({super.key, required this.authorization});

  @override
  Widget build(BuildContext context) {
    final a = authorization;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Authorization Details'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          children: [
            _infoCard('User', a.user),
            const SizedBox(height: 12),
            _infoCard('Access Type', a.accessType),
            const SizedBox(height: 12),
            _infoCard('User Name', a.userName),
            const SizedBox(height: 12),
            _infoCard('Password', a.password),
            const SizedBox(height: 12),
            _infoCard('Status', a.status),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF19243A))),
        ],
      ),
    );
  }
}
