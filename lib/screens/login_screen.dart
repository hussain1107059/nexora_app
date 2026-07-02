import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../utils/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyCodeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _companyCodeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    }
  }

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FBFF), Color(0xFFEAF3FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(color: Colors.blue.shade100.withOpacity(0.35), blurRadius: 24, offset: const Offset(0, 16)),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/nexora1.jpg', width: 70, height: 70, fit: BoxFit.contain),
                      const SizedBox(height: 18),
                      Text(
                        loc.appTitle,
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF14213D)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        loc.loginSubtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
                      ),
                      const SizedBox(height: 24),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _companyCodeController,
                              decoration: _fieldDecoration('Company Code'),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              decoration: _fieldDecoration(loc.emailField),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return loc.validationEmail;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              decoration: _fieldDecoration(loc.passwordField),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return loc.validationPassword;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _signIn,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  backgroundColor: const Color(0xFF2563EB),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                ),
                                child: Text(loc.signInButton, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/company_logo.jpeg', width: 22, height: 22, fit: BoxFit.contain),
                    const SizedBox(width: 8),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('BadhonByte', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF334155))),
                        Text('Technology Partner', style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Color(0xFF64748B))),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
