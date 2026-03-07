import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'app_bottom_nav_bar.dart';

class SSCEPrepApp extends StatelessWidget {
  const SSCEPrepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SSCE Prep Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const AppBottomNavBar(),
    );
  }
}