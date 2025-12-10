import 'package:flutter/material.dart';
import 'package:loyerapp/features/admin/admin_dashboard.dart';
import 'package:loyerapp/features/auth/splash_screen.dart';

import 'config/theme.dart';
// Nous importerons les vraies pages ici plus tard

void main() {
  runApp(const LoyerPayApp());
}

class LoyerPayApp extends StatelessWidget {
  const LoyerPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LoyerPay',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
