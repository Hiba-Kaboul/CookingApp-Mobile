// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class ProfileTitle extends StatelessWidget {
  final String name;
  final String bio;
  final String title;
  final int posts_count;

  const ProfileTitle({
    Key? key,
    required this.name,
    required this.bio,
    required this.title,
    required this.posts_count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 60,
        ),
        Text(
          name,
          style: AppTextStyles.heading,
        ),
        const SizedBox(
          height: 10,
        ),
        if (bio.isNotEmpty)
          Container(
            width: 150,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.otpGradientBottom,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    bio,
                    style: AppTextStyles.label,
                  ),
               const   SizedBox(width: 10,),
                  Image.asset("assets/images/Container.png")
                ],
              ),
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        Text(
          title,
          style: AppTextStyles.label,
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: 148,
          height: 60,
          decoration: BoxDecoration(
              color: AppColors.otpGradientMiddle,
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  posts_count.toString(),
                  style: AppTextStyles.appBarTitle2,
                ),
                const Text(
                  "وصفة منشورة",
                  style: AppTextStyles.otpNotReceived,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
