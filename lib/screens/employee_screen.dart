import 'package:flutter/material.dart';

import '../widgets/erp_drawer.dart';

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Employee'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      drawer: const ERPDrawer(currentRoute: '/employee'),
      body: const Center(
        child: Text('Employee Screen'),
      ),
    );
  }
}
