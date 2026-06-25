import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class Taps extends StatelessWidget {
  const Taps({super.key});

  @override
  Widget build(BuildContext context) {
    // نستخدم DefaultTabController هنا ليتحكم في الـ TabBar والـ TabBarView
    return const DefaultTabController(
      length: 2,
      child: Column(
        children: [
           TabBar(
            indicatorColor: AppColors.grey,
            labelColor: AppColors.primary,
            tabs: [
              Tab(text: "المفضلة"),
              Tab(text: "وصفاتي"),
              
            ],
          ),
          // نستخدم Expanded ليأخذ الـ TabBarView المساحة المتبقية فقط
           Expanded(
            child: TabBarView(
              children: [
                Center(child: Text("محتوى وصفاتي هنا")),
                Center(child: Text("محتوى المفضلة هنا")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}