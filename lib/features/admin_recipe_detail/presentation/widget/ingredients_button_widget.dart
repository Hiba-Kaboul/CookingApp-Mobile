// import 'package:flutter/material.dart';
// import 'package:project2/core/constants/app_colors.dart';
// import 'package:project2/core/constants/app_text_styles.dart';

// /// الزر العائم "المكونات" أسفل شاشة الطبخ الذكي
// class IngredientsButtonWidget extends StatelessWidget {
//   final VoidCallback onTap;

//   const IngredientsButtonWidget({
//     super.key,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(30),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
//         decoration: BoxDecoration(
//           color: AppColors.followButton,
//           borderRadius: BorderRadius.circular(30),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.3),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.menu_book_rounded, size: 16, color: AppColors.textDark),
//             const SizedBox(width: 6),
//             Text(
//               'المكونات',
//               style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(width: 6),
//             const Icon(Icons.list_alt_rounded, size: 16, color: AppColors.textDark),
//           ],
//         ),
//       ),
//     );
//   }
// }