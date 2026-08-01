import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/community_post_card.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: AppColors.primary,
        title: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "مجتمع المستخدمين",
              style: AppTextStyles.appBarTitle,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return const CommunityPostCard(
                  userName: "ياسين المنصوري",
                  timeAgo: "منذ ساعتين",
                  content:
                      "تجربة سلطة الكينوا الجديدة مع صلصة الليمون والأعشاب. الطعم خيالي ومنعش جداً!",
                  imagePath:
                      "assets/images/onboarding3.png", 
                  hashTag: "#وصفة_صحية",
                  likes: 124,
                  comments: 18,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
