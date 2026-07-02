import 'package:flutter/material.dart';

import '../widgets/erp_drawer.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customers = [
      {'org': 'Acme Corp', 'area': 'New York', 'amount': '12,500'},
      {'org': 'Globex Inc', 'area': 'London', 'amount': '8,300'},
      {'org': 'Initech', 'area': 'San Francisco', 'amount': '15,200'},
      {'org': 'Hooli', 'area': 'Palo Alto', 'amount': '22,000'},
      {'org': 'Umbrella Corp', 'area': 'Chicago', 'amount': '6,750'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Customer'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      drawer: const ERPDrawer(currentRoute: '/customer'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
                ),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1.5),
                    2: FlexColumnWidth(1.5),
                  },
                  children: [
                    const TableRow(
                      decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
                      children: const [
                        Padding(padding: EdgeInsets.all(14), child: Text('Organization', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
                        Padding(padding: EdgeInsets.all(14), child: Text('Area', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)))),
                        Padding(padding: EdgeInsets.all(14), child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A)), textAlign: TextAlign.right)),
                      ],
                    ),
                    ...customers.map((c) => TableRow(
                      children: [
                        Padding(padding: const EdgeInsets.all(14), child: Text(c['org']!)),
                        Padding(padding: const EdgeInsets.all(14), child: Text(c['area']!)),
                        Padding(padding: const EdgeInsets.all(14), child: Text(c['amount']!, style: const TextStyle(fontWeight: FontWeight.w600), textAlign: TextAlign.right)),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
