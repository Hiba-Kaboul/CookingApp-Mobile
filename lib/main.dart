import 'package:flutter/material.dart';
import 'package:project2/features/auth/presentation/pages/otp_page_forget.dart';
import 'package:project2/features/auth/presentation/pages/reset_password_page.dart';
import 'package:project2/features/splash/presentation/pages/splash_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}
