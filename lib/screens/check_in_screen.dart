import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/check_in.dart';
import 'check_in_detail_screen.dart';
import 'check_in_form_screen.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  List<CheckInSession> _data = [
    CheckInSession(
      date: DateTime(2026, 7, 12),
      title: 'Rahim',
      remarks: 'Client meeting & site visit',
      punches: [
        CheckInPunch(
          time: DateTime(2026, 7, 12, 9, 15),
          latitude: 23.8103, longitude: 90.4125,
          address: 'Motijheel, Dhaka',
          description: 'Client meeting with Green Agro',
          amount: 500,
        ),
        CheckInPunch(
          time: DateTime(2026, 7, 12, 14, 30),
          latitude: 23.7463, longitude: 90.3763,
          address: 'Uttara, Dhaka',
          description: 'Lunch with team',
          amount: 350,
        ),
      ],
    ),
    CheckInSession(
      date: DateTime(2026, 7, 13),
      title: 'Karim',
      remarks: 'Factory inspection',
      punches: [
        CheckInPunch(
          time: DateTime(2026, 7, 13, 8, 0),
          latitude: 23.6200, longitude: 90.5000,
          address: 'Narayanganj',
          description: 'Fuel',
          amount: 800,
        ),
        CheckInPunch(
          time: DateTime(2026, 7, 13, 11, 0),
          latitude: 23.6100, longitude: 90.5100,
          address: 'Adamjee EPZ',
          description: 'Toll',
          amount: 200,
        ),
        CheckInPunch(
          time: DateTime(2026, 7, 13, 16, 0),
          latitude: 23.7500, longitude: 90.4000,
          address: 'Old Dhaka',
        ),
      ],
    ),
  ];

  void _openForm([CheckInSession? session]) {
    Navigator.push<CheckInSession>(
      context,
      MaterialPageRoute(builder: (_) => CheckInFormScreen(session: session)),
    ).then((result) {
      if (result != null) {
        setState(() {
          if (session != null) {
            final index = _data.indexOf(session);
            if (index >= 0) _data[index] = result;
          } else {
            _data.insert(0, result);
          }
        });
      }
    });
  }

  void _view(CheckInSession session) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CheckInDetailScreen(session: session)),
    );
  }

  void _delete(CheckInSession session) {
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
              setState(() => _data.remove(session));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Check In'),
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
          final session = _data[index - 1];
          return _buildSlidableRow(session, index == _data.length);
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
          Expanded(flex: 2, child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
          Expanded(flex: 2, child: Text('Title', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
          Expanded(flex: 2, child: Text('Punches', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
          Expanded(flex: 3, child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF19243A)))),
        ],
      ),
    );
  }

  Widget _buildSlidableRow(CheckInSession session, bool isLast) {
    return ClipRRect(
      borderRadius: isLast ? BorderRadius.circular(10) : BorderRadius.zero,
      child: Slidable(
        key: ValueKey(session.hashCode),
        startActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _view(session),
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
              onPressed: (_) => _openForm(session),
              backgroundColor: const Color(0xFFD97706),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (_) => _delete(session),
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
            onTap: () => _openForm(session),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                children: [
                  Expanded(flex: 2, child: Text(_formatDate(session.date), style: const TextStyle(fontSize: 12))),
                  Expanded(flex: 2, child: Text(session.title, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
                  Expanded(flex: 2, child: Text('${session.totalPunches}', style: const TextStyle(fontSize: 12))),
                  Expanded(flex: 3, child: Text('\$${session.totalExpenses.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
