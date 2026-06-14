import 'package:flutter/material.dart';
import 'package:project2/core/constants/app_colors.dart';

class DotIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalPages;

  const DotIndicator({
    super.key,
    required this.currentIndex,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == currentIndex ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: index == currentIndex
                ? AppColors.dotActive
                : AppColors.dotInactive,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}