import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'src/core/theme/app_theme.dart';
import 'src/core/database/database_service.dart';
import 'src/features/onboarding/screens/onboarding_screen.dart';
import 'src/app/app_bottom_nav_bar.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive - no adapters needed, using plain maps
  await Hive.initFlutter();
  await Hive.openBox(quizResultsBox);
  await Hive.openBox(settingsBox);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const SSCEPrepApp());
}

class SSCEPrepApp extends StatelessWidget {
  const SSCEPrepApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bool onboardingDone = DatabaseService.isOnboardingDone();

    return MaterialApp(
      title: 'SSCE Prep Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: onboardingDone ? const AppBottomNavBar() : const OnboardingScreen(),
    );
  }
}