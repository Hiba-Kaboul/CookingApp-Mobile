import 'package:flutter/material.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/core/constants/app_text_styles.dart';
import 'package:project2/features/onboarding/data/models/onboarding_model.dart';


import '../../../auth/presentation/pages/register_page.dart';
import 'dot_indicator.dart';
import 'onboarding_button.dart';

class OnboardingContent extends StatelessWidget {
  final OnboardingModel model;
  final int currentIndex;
  final int totalPages;
  final VoidCallback onNext;

  const OnboardingContent({
    super.key,
    required this.model,
    required this.currentIndex,
    required this.totalPages,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DotIndicator(
            currentIndex: currentIndex,
            totalPages: totalPages,
          ),
          const SizedBox(height: 24),
          Text(
            model.title,
            style: AppTextStyles.header,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            model.subtitle,
            style: AppTextStyles.text16_400L,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          OnboardingButton(
            label: currentIndex == totalPages - 1 ? 'ابدأ الآن' : 'التالي',
            onTap: currentIndex == totalPages - 1
                ? () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    )
                : onNext,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
