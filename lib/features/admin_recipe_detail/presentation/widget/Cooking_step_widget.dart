import 'package:flutter/material.dart';
import 'package:project2/core/constants/app_colors.dart';

/// يعرض: "الخطوة X من Y" + رقم الخطوة الكبير + كرت النص التوضيحي
class CookingStepWidget extends StatelessWidget {
  final int currentStep; // يبدأ من 1
  final int totalSteps;
  final String instruction;

  const CookingStepWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.instruction,
  });

  // تحويل الرقم الإنجليزي إلى أرقام عربية هندية (١٢٣...) متل التصميم
  String _toArabicNumber(int number) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .split('')
        .map((d) => arabicDigits[int.parse(d)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'الخطوة ${_toArabicNumber(currentStep)} من ${_toArabicNumber(totalSteps)}',
          style: const TextStyle(
            color: AppColors.followButton,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _toArabicNumber(currentStep),
          style: const TextStyle(
            color: AppColors.followButton,
            fontSize: 56,
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 22),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            instruction,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              height: 1.7,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}