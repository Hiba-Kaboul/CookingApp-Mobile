import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../auth/presentation/widgets/custom_text_field.dart';
import '../widgets/carouselslider.dart';
import '../widgets/category_list.dart';
import '../widgets/community_post_card.dart';
import '../widgets/photo.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _searchController = TextEditingController();

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
              "المجتمع العام",
              style: AppTextStyles.appBarTitle,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "صباح الخير، جنان 👋",
                  style: AppTextStyles.title,
                ),
              ),
              CustomTextField(
                label: "",
                hint: AppStrings.search,
                suffixIcon: Icons.search,
                controller: _searchController,
                // isPassword: true,
              ),
              const SizedBox(
                height: 10,
              ),
              Photo(),
              const SizedBox(
                height: 10,
              ),
              const CategoryList(),
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  AppStrings.popular,
                  style: AppTextStyles.title,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
      
              const SizedBox(
                height:
                    170, 
                child: Carouselslider(),
              ),
              const SizedBox(
                height: 10,
              ),
              // ListView.builder(
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   itemCount: 5,
              //   itemBuilder: (context, index) {
              //     return const CommunityPostCard(
              //       userName: "ياسين المنصوري",
              //       postId: 1,
              //       timeAgo: "منذ ساعتين",
              //       content:
              //           "تجربة سلطة الكينوا الجديدة مع صلصة الليمون والأعشاب. الطعم خيالي ومنعش جداً!",
              //      mediaList: [], // تأكدي من مسار الصورة
              //       // hashTag: "#وصفة_صحية",
              //       avatar: null,
              //        post: post,
                   
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
