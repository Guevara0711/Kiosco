import 'package:flutter/material.dart';
import 'package:kiosco/core/themes/app_theme.dart';
import 'package:kiosco/presentation/pages/auth/login_page.dart';

void main() {
  runApp(const KioscoApp());
}

class KioscoApp extends StatelessWidget {
  const KioscoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kiosco',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
