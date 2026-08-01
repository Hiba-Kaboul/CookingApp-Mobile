import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/api/my_posts_view.dart';
import '../../data/api/my_saved_posts_api.dart';
import '../bloc_my_approved_posts.dart/my_posts_bloc.dart';
import '../bloc_my_approved_posts.dart/my_posts_event.dart';
import '../bloc_my_saved_posts.dart/saved_posts_bloc.dart';
import '../bloc_my_saved_posts.dart/saved_posts_event.dart';
import '../pages/my_posts_page.dart';
import '../pages/my_saved_posts_page.dart';

class Taps extends StatelessWidget {
  const Taps({super.key});

  @override
  Widget build(BuildContext context) {
    // نستخدم DefaultTabController هنا ليتحكم في الـ TabBar والـ TabBarView
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            indicatorColor: AppColors.grey,
            labelColor: AppColors.primary,
            tabs: [
              Tab(text: "محفوظاتي"),
              Tab(text: "وصفاتي"),
            ],
          ),
          // نستخدم Expanded ليأخذ الـ TabBarView المساحة المتبقية فقط
          Expanded(
            child: TabBarView(
              children: [
                BlocProvider(
                  create: (_) => SavedItemsBloc(SavedItemsApi())
                    ..add(GetSavedItemsEvent()),
                  child: const SavedItemsPage(),
                ),
                BlocProvider(
                  create: (_) =>
                      MyPostsBloc(MyPostsViewApi())..add(GetMyPostsEvent()),
                  child: const MyPostsPage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
