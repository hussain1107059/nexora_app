import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/payment.dart';
import 'payment_detail_screen.dart';
import 'payment_form_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final List<Payment> _payments = [
    Payment(
      transId: 'PAY-001',
      date: DateTime(2026, 6, 10, 10, 30),
      transactionType: 'Paid',
      paymentType: 'Cheque',
      bankName: 'Sonali Bank Ltd',
      type: 'Expense',
      selectName: 'Supplier X',
      amount: 25000,
      description: 'Office supply purchase',
    ),
    Payment(
      transId: 'PAY-002',
      date: DateTime(2026, 6, 15, 14, 0),
      transactionType: 'Received',
      paymentType: 'Bank Transfer',
      bankName: 'Dutch Bangla Bank',
      type: 'Income',
      selectName: 'Client A',
      amount: 75000,
      description: 'Project advance payment',
    ),
    Payment(
      transId: 'PAY-003',
      date: DateTime(2026, 6, 20, 9, 15),
      transactionType: 'Paid',
      paymentType: 'Cash',
      bankName: 'Islami Bank BD',
      type: 'Expense',
      selectName: 'Employee 1',
      amount: 5000,
      description: 'Travel allowance',
    ),
  ];

  void _openForm([Payment? payment]) async {
    final result = await Navigator.push<Payment>(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentFormScreen(
          payment: payment,
          nextId: payment == null ? _payments.length + 1 : null,
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        if (payment != null) {
          final idx = _payments.indexOf(payment);
          _payments[idx] = result;
        } else {
          _payments.add(result);
        }
      });
    }
  }

  void _viewPayment(Payment payment) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PaymentDetailScreen(payment: payment)),
    );
  }

  void _delete(Payment payment) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Payment'),
        content: Text('Delete payment "${payment.transId}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() => _payments.remove(payment));
              Navigator.pop(ctx);
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
        title: const Text('Payment'),
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
      body: _payments.isEmpty
          ? const Center(child: Text('No payments added yet', style: TextStyle(color: Colors.black54)))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
              itemCount: _payments.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) return _buildHeader();
                final payment = _payments[i - 1];
                final isLast = i == _payments.length;
                return _buildSlidableRow(payment, isLast);
              },
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: const Row(
        children: [
          Expanded(flex: 2, child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 2, child: Text('Trans ID', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 1, child: Text('Type', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 1, child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
          Expanded(flex: 2, child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
        ],
      ),
    );
  }

  Widget _buildSlidableRow(Payment payment, bool isLast) {
    return ClipRRect(
      borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(16)) : BorderRadius.zero,
      child: Slidable(
        key: ValueKey(payment.transId),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _viewPayment(payment),
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              icon: Icons.visibility,
              label: 'View',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _openForm(payment),
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (_) => _delete(payment),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text(_formatDate(payment.date), style: const TextStyle(fontSize: 12))),
                Expanded(flex: 2, child: Text(payment.transId, style: const TextStyle(fontSize: 12))),
                Expanded(flex: 1, child: Text(payment.type, style: const TextStyle(fontSize: 12))),
                Expanded(flex: 1, child: Text('\$${payment.amount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12))),
                Expanded(flex: 2, child: Text(payment.selectName, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
