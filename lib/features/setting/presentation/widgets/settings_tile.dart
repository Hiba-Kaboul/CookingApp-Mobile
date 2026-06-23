import 'package:flutter/material.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/core/constants/app_text_styles.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final Widget? trailingBadge; // مثل شارة "العربية"
  final bool showChevron;
  final bool isDestructive;

  const SettingsTile({
    super.key,
    required this.title,
    required this.icon,
    this.iconColor,
    this.onTap,
    this.trailingBadge,
    this.showChevron = true,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = isDestructive ? AppColors.primary : AppColors.textDark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            if (showChevron)
              const Icon(Icons.chevron_left, size: 20, color: AppColors.grey),
            const Spacer(),
            if (trailingBadge != null) ...[
              trailingBadge!,
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: AppTextStyles.label.copyWith(
                color: color,
                fontWeight: isDestructive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            const SizedBox(width: 10),
            Icon(icon, size: 20, color: iconColor ?? AppColors.primary),
          ],
        ),
      ),
    );
  }
}