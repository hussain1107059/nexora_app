import 'package:flutter/material.dart';

import '../models/check_in.dart';

class CheckInDetailScreen extends StatelessWidget {
  final CheckInSession session;

  const CheckInDetailScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Check In Details'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          children: [
            _infoCard('Title', session.title),
            const SizedBox(height: 12),
            _infoCard('Date', _formatDate(session.date)),
            if (session.remarks.isNotEmpty) ...[
              const SizedBox(height: 12),
              _infoCard('Remarks', session.remarks),
            ],
            const SizedBox(height: 12),
            _buildPunchesSection(),
            const SizedBox(height: 12),
            _infoCard('Total Expenses', '\$${session.totalExpenses.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildPunchesSection() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Location Punches', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('${session.totalPunches} locations', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF2563EB))),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...session.punches.asMap().entries.map((entry) {
            final punch = entry.value;
            return Padding(
              padding: EdgeInsets.only(top: entry.key > 0 ? 10 : 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2563EB),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_formatTime(punch.time),
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF19243A))),
                        const SizedBox(height: 2),
                        Text(punch.address, style: const TextStyle(fontSize: 13, color: Color(0xFF334155))),
                        Text('${punch.latitude.toStringAsFixed(4)}, ${punch.longitude.toStringAsFixed(4)}',
                            style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                        if (punch.description.isNotEmpty || punch.amount > 0) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                if (punch.description.isNotEmpty)
                                  Expanded(
                                    child: Text(punch.description,
                                        style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
                                  ),
                                if (punch.amount > 0) ...[
                                  const SizedBox(width: 8),
                                  Text('\$${punch.amount.toStringAsFixed(0)}',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF19243A))),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
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
