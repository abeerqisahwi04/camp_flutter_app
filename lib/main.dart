import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/splash/splash_screen.dart';

void main() {
  runApp(const GoCampApp());
}

class GoCampApp extends StatelessWidget {
  const GoCampApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoCamp',
      home: SplashScreen(),
    );
  }
}
