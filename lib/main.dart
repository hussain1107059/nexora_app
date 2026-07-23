import 'package:flutter/material.dart';

import 'localization/app_localizations.dart';
import 'screens/app_shell.dart';
import 'screens/login_screen.dart';
import 'screens/module_screen.dart';
import 'services/storage_service.dart';
import 'utils/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _localizations = AppLocalizations();

  @override
  Widget build(BuildContext context) {
    return AppLocalizationsProvider(
      notifier: _localizations,
      child: Builder(
        builder: (context) {
          final loc = AppLocalizations.of(context);
          final isLoggedIn = StorageService.getLoginStatus();

          return MaterialApp(
            title: loc.appTitle,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
              scaffoldBackgroundColor: Colors.grey.shade50,
            ),
            initialRoute: isLoggedIn ? AppRoutes.dashboard : AppRoutes.login,
            routes: {
              AppRoutes.login: (context) => const LoginScreen(),
              AppRoutes.dashboard: (context) => const AppShell(),
              AppRoutes.module: (context) => const ModuleScreen(),
            },
          );
        },
      ),
    );
  }
}
