import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'features/splash/splash_screen.dart';

void main() {
  runApp(const GoCampApp());
}

class GoCampApp extends StatelessWidget {
  const GoCampApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: kBgDark, useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}
