import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/features/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // تجهيز قبل async
  await Firebase.initializeApp(); // تهيئة فايربيس

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
