import 'package:flutter/material.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/core/constants/app_text_styles.dart';

class AdminRecipeAuthorWidget extends StatelessWidget {
  final String userName;
  final String? userAvatar;

  const AdminRecipeAuthorWidget({
    super.key,
    required this.userName,
    this.userAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              userName,
              style: AppTextStyles.title,
            ),
            Text(
              "طبخ منزلي",
              style: AppTextStyles.subHeading.copyWith(fontSize: 11),
            ),
          ],
        ),
        const SizedBox(width: 10),
        CircleAvatar(
          radius: 22,
          backgroundImage: userAvatar != null && userAvatar!.isNotEmpty
              ? NetworkImage(userAvatar!)
              : null,
          child: userAvatar == null || userAvatar!.isEmpty
              ? const Icon(Icons.person)
              : null,
        ),
      ],
    );
  }
}
