// presentation/widgets/shopping_list_widgets.dart
import 'package:flutter/material.dart';
import 'package:project2/core/constants/app_colors.dart';

/// ====================================================================
/// شريط التطبيق العلوي
/// ====================================================================
class ShoppingAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onMenuTap;

  const ShoppingAppBarWidget({
    super.key,
    this.onSearchTap,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      centerTitle: true,
     
      title: const Text(
        'قائمة التسوق',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// ====================================================================
/// صورة الرأس أعلى كرت القائمة
/// ====================================================================
class ShoppingListHeaderImageWidget extends StatelessWidget {
  final String imageUrl;

  const ShoppingListHeaderImageWidget({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: SizedBox(
        height: 100,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            
            Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.ResetPasswordBackgroundTextField,
                child:
                    const Icon(Icons.image, color: AppColors.grey, size: 40),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.ResetPasswordTextField.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ====================================================================
/// شريط الإجراءات الثابت (تحديد الكل + مشترى + غير مشترى)
/// ====================================================================
class ShoppingActionsBarWidget extends StatelessWidget {
  final int totalCount;
  final int selectedCount;
  final bool allSelected;
  final ValueChanged<bool?> onSelectAll;
  final VoidCallback onMarkPurchased;
  final VoidCallback onMarkUnpurchased;

  const ShoppingActionsBarWidget({
    super.key,
    required this.totalCount,
    required this.selectedCount,
    required this.allSelected,
    required this.onSelectAll,
    required this.onMarkPurchased,
    required this.onMarkUnpurchased,
  });

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedCount > 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder.withOpacity(0.6)),
      ),
      child: Row(
        children: [
          // تحديد الكل
          Checkbox(
            value: allSelected,
            activeColor: AppColors.primary,
            onChanged: onSelectAll,
          ),
          Text(
            hasSelection ? "$selectedCount محدد" : "تحديد الكل",
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const Spacer(),
          _ActionChip(
            icon: Icons.check_circle_outline_rounded,
            label: "مشترى",
            color: AppColors.primary,
            enabled: hasSelection,
            onTap: onMarkPurchased,
          ),
          const SizedBox(width: 6),
          _ActionChip(
            icon: Icons.remove_circle_outline_rounded,
            label: "غير مشترى",
            color: AppColors.light_brown,
            enabled: hasSelection,
            onTap: onMarkUnpurchased,
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool enabled;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = enabled ? color : AppColors.hintText;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: effectiveColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: effectiveColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: effectiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ====================================================================
/// صف عنصر واحد بقائمة التسوق
/// ====================================================================
class ShoppingItemTileWidget extends StatelessWidget {
  final String name;
  final bool isPurchased;
  final bool isSelected;
  final ValueChanged<bool?> onSelectChanged;
  final VoidCallback onDelete;

  const ShoppingItemTileWidget({
    super.key,
    required this.name,
    required this.isPurchased,
    required this.isSelected,
    required this.onSelectChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPurchased
            ? AppColors.otpCardBackground.withOpacity(0.6)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected
              ? AppColors.primary.withOpacity(0.6)
              : AppColors.inputBorder.withOpacity(0.7),
          width: isSelected ? 1.4 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // checkbox التحديد
          Checkbox(
            value: isSelected,
            activeColor: AppColors.primary,
            onChanged: onSelectChanged,
          ),
          // شارة صغيرة تدل إذا مشترى
          if (isPurchased)
            Container(
              margin: const EdgeInsets.only(left: 6),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "تم الشراء",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          Expanded(
            child: Text(
              name,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isPurchased
                    ? AppColors.hintText
                    : AppColors.textDark,
                decoration:
                    isPurchased ? TextDecoration.lineThrough : null,
                decorationColor: AppColors.hintText,
              ),
            ),
          ),
          const SizedBox(width: 4),
          // زر الحذف — بس جنب العنصر
          InkWell(
            onTap: onDelete,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.red,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}