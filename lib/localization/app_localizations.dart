import 'package:flutter/material.dart';

enum AppLanguage { english, bangla }

class AppLocalizations extends ChangeNotifier {
  AppLanguage _language = AppLanguage.english;

  AppLanguage get language => _language;
  bool get isBangla => _language == AppLanguage.bangla;

  void setLanguage(AppLanguage language) {
    if (_language == language) return;
    _language = language;
    notifyListeners();
  }

  static AppLocalizations of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AppLocalizationsProvider>();
    if (provider == null) {
      throw FlutterError('AppLocalizationsProvider not found in widget tree');
    }
    return provider.notifier!;
  }

  String get appTitle => isBangla ? 'নেক্সোরা ইআরপি' : 'Nexora ERP';
  String get drawerTitle => appTitle;
  String get drawerSubtitle => isBangla ? 'ইআরপি স্যুট' : 'ERP Suite';
  String get dashboardTitle => isBangla ? 'ড্যাশবোর্ড' : 'Dashboard';
  String get modulesTitle => isBangla ? 'মডিউল' : 'Modules';
  String get signOut => isBangla ? 'লগ আউট' : 'Sign Out';
  String get languageLabel => isBangla ? 'ভাষা' : 'Language';
  String get englishLabel => 'English';
  String get banglaLabel => isBangla ? 'বাংলা' : 'Bangla';
  String get loginSubtitle => isBangla ? 'অ্যাকাউন্ট, সেল, অ্যাডমিন, সাপ্লাই, স্টক এবং রিপোর্ট পরিচালনা করতে লগইন করুন।' : 'Login to manage accounts, sale, administration, supply, stock and reports.';
  String get signInButton => isBangla ? 'লগ ইন' : 'Sign In';
  String get emailField => isBangla ? 'ইমেল বা ব্যবহারকারীর নাম' : 'Email or Username';
  String get passwordField => isBangla ? 'পাসওয়ার্ড' : 'Password';
  String get validationEmail => isBangla ? 'অনুগ্রহ করে ইমেল বা ব্যবহারকারীর নাম লিখুন' : 'Please enter your email or username';
  String get validationPassword => isBangla ? 'অনুগ্রহ করে পাসওয়ার্ড লিখুন' : 'Please enter your password';
  String get notifications => isBangla ? 'নোটিফিকেশন' : 'Notifications';
}

class AppLocalizationsProvider extends InheritedNotifier<AppLocalizations> {
  const AppLocalizationsProvider({required AppLocalizations notifier, required Widget child})
      : super(notifier: notifier, child: child);
}
