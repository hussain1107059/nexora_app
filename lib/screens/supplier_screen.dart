import 'package:flutter/material.dart';

import '../widgets/erp_drawer.dart';

class SupplierScreen extends StatelessWidget {
  const SupplierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final suppliers = [
      {'org': 'TechSupply Co', 'area': 'Shenzhen', 'amount': '45,000'},
      {'org': 'RawMaterials Ltd', 'area': 'Mumbai', 'amount': '32,000'},
      {'org': 'PartsExpress', 'area': 'Detroit', 'amount': '28,500'},
      {'org': 'Global Logistics', 'area': 'Rotterdam', 'amount': '19,800'},
      {'org': 'QualityParts Inc', 'area': 'Taipei', 'amount': '14,200'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Supplier'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      drawer: const ERPDrawer(currentRoute: '/supplier'),
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
                    ...suppliers.map((s) => TableRow(
                      children: [
                        Padding(padding: const EdgeInsets.all(14), child: Text(s['org']!)),
                        Padding(padding: const EdgeInsets.all(14), child: Text(s['area']!)),
                        Padding(padding: const EdgeInsets.all(14), child: Text(s['amount']!, style: const TextStyle(fontWeight: FontWeight.w600), textAlign: TextAlign.right)),
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
