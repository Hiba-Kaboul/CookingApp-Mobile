import 'package:flutter/material.dart';
import 'package:project2/core/constants/app_text_styles.dart';

class SettingsSectionTitle extends StatelessWidget {
  final String title;

  const SettingsSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(title, style: AppTextStyles.label),
      ),
    );
  }
}