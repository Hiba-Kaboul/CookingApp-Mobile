import 'package:flutter/material.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/core/constants/app_text_styles.dart';

class RecipeBottomButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RecipeBottomButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        24,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: SizedBox(
        height: 54,
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: const Icon(
            Icons.auto_awesome,
          ),
          label: Text(
            "ابدأ الطبخ الذكي",
            style: AppTextStyles.button,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }
}
