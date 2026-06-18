import 'package:flutter/material.dart';
import 'package:project2/core/constants/app_text_styles.dart';



class OnboardingImage extends StatelessWidget {
  final String image;
  final VoidCallback onSkip;
  final bool showSkip;

  const OnboardingImage({
    super.key,
    required this.image,
    required this.onSkip,
    required this.showSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الصورة
        Positioned.fill(
          child: Image.asset(
            image,
            fit: BoxFit.fill,
          ),
        ),

        // زر تخطى
        if (showSkip)
          Positioned(
            top: 52,
            left: 24,
            child: GestureDetector(
              onTap: onSkip,
              child: Text('تخطى', style: AppTextStyles.text16_600L),
            ),
          ),
      ],
    );
  }
}