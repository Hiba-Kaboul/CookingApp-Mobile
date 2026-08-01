import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/api_url.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../auth/presentation/widgets/custom_text_field.dart';
import '../../data/api/cuisine_api.dart';
import '../../data/api/recipes_api.dart'; // تأكد من مسار الـ API الصحيح    // تأكد من مسار الـ BLoC الصحيح
import '../bloc/cuisine/cuisine_bloc.dart';
import '../bloc/cuisine/cuisine_event.dart';
import '../bloc_homepage_posts/recipes_bloc.dart';
import '../bloc_homepage_posts/recipes_event.dart';
import '../bloc_homepage_posts/recipes_state.dart';
import '../widgets/carouselslider.dart';
import '../widgets/category_list.dart';
import '../widgets/community_post_card.dart';
import '../widgets/photo.dart';
import '../widgets/recipe_post_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
      return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => RecipesBloc(RecipesApi())..add(GetRecipesEvent()),
        ),
        BlocProvider(
          create: (_) {
            final dio = Dio(BaseOptions(baseUrl: ApiUrl.baseUrl));
            return CuisineBloc(CuisineApi(dio))..add(GetCuisinesEvent());
          },
        ),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      context.read<RecipesBloc>().add(LoadMoreRecipesEvent());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

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
      body: BlocBuilder<RecipesBloc, RecipesState>(
        builder: (context, state) {
          if (state is RecipesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RecipesError) {
            return Center(child: Text(state.message));
          }

          // سنستخدم SingleChildScrollView لجعل العناصر العلوية (البحث، السلايدر، التصنيفات) قابلة للتمرير مع القائمة
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
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
                  ),
                  const SizedBox(height: 10),
                  const Photo(),
                  const SizedBox(height: 10),
                  const CategoryList(),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      AppStrings.popular,
                      style: AppTextStyles.title,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const SizedBox(
                    height: 170,
                    child: Carouselslider(),
                  ),
                  const SizedBox(height: 10),

                  // عرض الوصفات القادمة من الـ BLoC
                  if (state is RecipesSuccess) ...[
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.recipes.length + (state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.recipes.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final recipe = state.recipes[index];
                        return RecipePostCard(
                          postId: recipe.id,
                          userName: recipe.user.name,
                          avatar: recipe.user
                              .avatar, // تأكد من وجوده في RecipeUser كما عدلناه سابقاً
                          content: recipe.description,
                          mediaList: recipe.media,
                          recipe: recipe,
                          timeAgo: recipe.createdAt,
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
