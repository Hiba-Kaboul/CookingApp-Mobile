import 'package:flutter/material.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/core/constants/app_text_styles.dart';

class OnboardingButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const OnboardingButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: AppTextStyles.text16_600L),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}