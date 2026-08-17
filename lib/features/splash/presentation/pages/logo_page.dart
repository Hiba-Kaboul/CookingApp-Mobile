import 'dart:async';

import 'package:flutter/material.dart';
import 'splash_page.dart';

class LogoPage extends StatefulWidget {
  const LogoPage({super.key});

  @override
  State<LogoPage> createState() => _LogoPageState();
}

class _LogoPageState extends State<LogoPage>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // مدة حركة اللوغو
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // يبدأ من تحت الشاشة ويطلع لفوق
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // تشغيل الحركة
    _controller.forward();

    // بعد انتهاء الحركة + 3 ثواني
    _goToSplash();
  }

  Future<void> _goToSplash() async {
    // مدة الحركة
    await Future.delayed(const Duration(seconds: 1));

    // يبقى اللوغو ظاهر 3 ثواني
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const SplashPage(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6E8),

      body: Center(
        child: SlideTransition(
          position: _slideAnimation,

          child: Image.asset(
            "assets/images/12.png",

            // إذا بدك حجم محدد
            width: 180,
          ),
        ),
      ),
    );
  }
}