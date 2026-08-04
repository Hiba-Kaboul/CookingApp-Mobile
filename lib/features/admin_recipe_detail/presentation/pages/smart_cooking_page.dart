

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:project2/features/admin_recipe_detail/presentation/widget/Cooking_navigation_widget.dart';
import 'package:project2/features/admin_recipe_detail/presentation/widget/Cooking_read_widget.dart';
import 'package:project2/features/admin_recipe_detail/presentation/widget/Cooking_step_widget.dart';
import 'package:project2/features/admin_recipe_detail/presentation/widget/ingredients_button_widget.dart';


class SmartCookingPage extends StatefulWidget {
  final List<String> steps;
  final String imageUrl;

  const SmartCookingPage({
    super.key,
    required this.steps,
    required this.imageUrl,
  });

  @override
  State<SmartCookingPage> createState() => _SmartCookingPageState();
}

class _SmartCookingPageState extends State<SmartCookingPage> {
  int currentIndex = 0;

  void _goNext() {
    if (currentIndex < widget.steps.length - 1) {
      setState(() => currentIndex++);
    }
  }

  void _goPrevious() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final instruction = widget.steps[currentIndex];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF241109),
        body: Stack(
          children: [
            // صورة الخلفية
            Positioned.fill(
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: const Color(0xFF241109)),
              ),
            ),
            // طبقة التعتيم
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(color: Colors.black.withOpacity(0.78)),
              ),
            ),
            // المحتوى
            SafeArea(
              child: Column(
                children: [
                  _buildTopBar(context),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          CookingStepWidget(
                            currentStep: currentIndex + 1,
                            totalSteps: widget.steps.length,
                            instruction: instruction,
                          ),
                          const SizedBox(height: 34),
                          CookingReadWidget(
                            key: ValueKey(currentIndex),
                            instruction: instruction,
                          ),
                          const SizedBox(height: 34),
                          CookingNavigationWidget(
                            onNext: currentIndex < widget.steps.length - 1
                                ? _goNext
                                : null,
                            onPrevious: currentIndex > 0 ? _goPrevious : null,
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // زر المكونات
            // Positioned(
            //   bottom: 24,
            //   left: 0,
            //   right: 0,
            //   child: Center(
            //     child: IngredientsButtonWidget(onTap: () {}),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
       mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'وضع الطبخ الذكي',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 20,),
          InkWell(
            onTap: () => Navigator.maybePop(context),
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.close, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}