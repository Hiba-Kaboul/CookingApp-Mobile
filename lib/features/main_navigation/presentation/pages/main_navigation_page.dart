import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/features/auth/presentation/pages/login_page.dart';
import 'package:project2/features/community/presentation/pages/home_page.dart';
import 'package:project2/features/setting/presentation/bloc/settings_event.dart';
import '../../../add_recipe/data/api/categories_api.dart';
import '../../../add_recipe/data/api/create_post_api.dart';
import '../../../add_recipe/presentation/bloc/create_post_bloc.dart';
import '../../../add_recipe/presentation/bloc_categories/categories_bloc.dart';
import '../../../add_recipe/presentation/bloc_categories/categories_event.dart';
import '../../../add_recipe/presentation/pages/add_recipe_page.dart';
import '../../../community/data/api/delete_post_api.dart';
import '../../../community/data/api/like_unlike_posts_api.dart';
import '../../../community/data/api/recipes_api.dart';
import '../../../community/data/api/save_unsave_posts_api.dart';
import '../../../community/data/api/users_api.dart';
import '../../../community/presentation/bloc/users_posts_bloc.dart';
import '../../../community/presentation/bloc/users_posts_event.dart';
import '../../../community/presentation/bloc_delete_post/delete_users_posts_bloc.dart';
import '../../../community/presentation/bloc_homepage_posts/recipes_bloc.dart';
import '../../../community/presentation/bloc_homepage_posts/recipes_event.dart';
import '../../../community/presentation/bloc_liked_posts/likeed_unliked_posts_bloc.dart';
import '../../../community/presentation/bloc_saved_posts/saved_unsaved_posts_bloc.dart';
import '../../../community/presentation/pages/users_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../setting/data/api/settings_api.dart';
import '../../../setting/presentation/bloc/settings_bloc.dart';
import '../../widgets/custom_bottom_nav_bar.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int currentIndex = 0;

  // تحويل القائمة إلى Getter
  List<Widget> get pages => [
        // في ملف MainNavigationPage.dart ضمن قائمة الـ pages:

        MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => RecipesBloc(RecipesApi())..add(GetRecipesEvent()),
            ),
            BlocProvider(
              create: (_) => DeleteUsersPostsBloc(DeletePostApi()),
            ),
            BlocProvider(
              create: (_) => LikeUnlikePostsBloc(LikeUnlikePostsApi()),
            ),
            BlocProvider(
              create: (_) => SaveUnlikePostsBloc(SaveUnsavePostsApi()),
            ),
          ],
          child: const HomePage(),
        ),

        // في ملف MainNavigationPage.dart

        BlocProvider(
          create: (_) => UsersPostsBloc(UsersPostsApi()),
          child: MultiBlocProvider(
            // إضافة هذا ليحتوي على كِلا الـ Bloc
            providers: [
              BlocProvider(
                  create: (_) => UsersPostsBloc(UsersPostsApi())
                    ..add(GetUsersPostsEvent())),
              BlocProvider(
                  create: (_) => DeleteUsersPostsBloc(DeletePostApi())),
              BlocProvider(
                create: (_) => LikeUnlikePostsBloc(
                  LikeUnlikePostsApi(),
                ),
              ),
              BlocProvider(
                create: (_) => SaveUnlikePostsBloc(
                  SaveUnsavePostsApi(),
                ),
              ),
              BlocProvider(
                create: (_) => SaveUnlikePostsBloc(
                  SaveUnsavePostsApi(),
                ),
              ),
            ],
            child: const UsersPage(),
          ),
        ),

        MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => CreatePostBloc(
                CreatePostApi(),
              ),
            ),
            BlocProvider(
              create: (_) => CategoriesBloc(
                CategoriesApi(),
              )..add(GetCategoriesEvent()),
            ),
          ],
          child: const AddRecipeScreen(),
        ),
// المطبخ الذكي
        Center(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
              );
            },
            child: const Text('Favorites Page'),
          ),
        ),

        BlocProvider(
          create: (_) => SettingsBloc(SettingsApi())
            ..add(GetProfileEvent()), // لا تنسَ إطلاق الحدث لجلب البيانات
          child: const ProfilePage(),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // استدعاء الـ getter هنا
      body: pages[currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
