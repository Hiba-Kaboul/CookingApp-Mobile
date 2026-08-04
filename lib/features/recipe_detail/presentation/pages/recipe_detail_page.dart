import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/core/constants/app_text_styles.dart';
import 'package:project2/features/recipe_detail/data/models/recipe_detail_model.dart';
import 'package:project2/features/recipe_detail/presentation/bloc/recipe_detail_bloc.dart';
import 'package:project2/features/recipe_detail/presentation/bloc/recipe_detail_event.dart';
import 'package:project2/features/recipe_detail/presentation/bloc/recipe_detail_state.dart';
import 'package:project2/features/recipe_detail/presentation/pages/smart_cooking_page_2.dart';
import 'package:project2/features/recipe_detail/presentation/widget/recipe_author_widget.dart';
import 'package:project2/features/recipe_detail/presentation/widget/recipe_bottom_button.dart';
import 'package:project2/features/recipe_detail/presentation/widget/recipe_header_widget.dart';
import 'package:project2/features/recipe_detail/presentation/widget/recipe_tabs_widget.dart';

class RecipeDetailPage extends StatefulWidget {
  final int id;

  const RecipeDetailPage({
    super.key,
    required this.id,
  });

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  @override
  void initState() {
    super.initState();

    context.read<RecipeDetailBloc>().add(GetRecipeDetail(widget.id));
  }

  bool isFavorite = true;

  int servings = 4;

  RecipeTab selectedTab = RecipeTab.ingredients;

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: BlocBuilder<RecipeDetailBloc, RecipeDetailState>(
          builder: (context, state) {
            if (state is RecipeDetailLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is RecipeDetailError) {
              return Center(
                child: Text(state.message),
              );
            }

            if (state is RecipeDetailLoaded) {
              final recipe = state.recipe;

              return Scaffold(
                backgroundColor: AppColors.background,
                body: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          RecipeHeaderWidget(
                            media: recipe.media,
                            isFavorite: isFavorite,
                            onFavorite: () {
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                            },
                            onBack: () {
                              Navigator.pop(context);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 18),
                                Text(
                                  recipe.title,
                                  style: AppTextStyles.heading,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  recipe.description,
                                  style: AppTextStyles.subHeading
                                      .copyWith(height: 1.6),
                                ),
                                const SizedBox(height: 18),
                                RecipeAuthorWidget(
                                  userName: recipe.userName,
                                  userAvatar: recipe.userAvatar,
                                ),
                                const SizedBox(height: 18),
                                _buildStats(recipe),
                                const SizedBox(height: 20),
                                RecipeTabsWidget(
                                  selectedTab: selectedTab,
                                  onChanged: (tab) {
                                    setState(() {
                                      selectedTab = tab;
                                    });
                                  },
                                ),
                                const SizedBox(height: 20),
                                _buildTabContent(recipe),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: RecipeBottomButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SmartCookingPage2(
          steps: recipe.steps
              .map((step) => step.description)
              .toList(),
          imageUrl: recipe.media.isNotEmpty
              ? recipe.media.first.url
              : '',
        ),
      ),
    );
  },
),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ));
  }

  Widget _buildStats(RecipeDetailModel recipe) {
    return Row(
      children: [
        // Expanded(
        //   child: _statItem(
        //     Icons.local_fire_department,
        //     "420 سعرة",
        //   ),
        // ),
        const SizedBox(width: 10),
        Expanded(
          child: _statItem(
            Icons.people,
            "${recipe.servings} أشخاص ",
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statItem(
            Icons.timer,
            _formatDuration(recipe.durationMinutes),
          ),
        ),
      ],
    );
  }

  String _formatDuration(int totalMinutes) {
    if (totalMinutes <= 0) return "0 دقيقة";
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours > 0 && minutes > 0) {
      return "$hours ساعة و $minutes دقيقة";
    }
    if (hours > 0) return "$hours ساعة";
    return "$minutes دقيقة";
  }

  Widget _statItem(
    IconData icon,
    String text,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.otpCardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: AppTextStyles.label,
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(RecipeDetailModel recipe) {
    switch (selectedTab) {
      case RecipeTab.ingredients:
        return _buildIngredients(recipe);

      case RecipeTab.steps:
        return _buildSteps(recipe);

      case RecipeTab.reviews:
        return Center(
          child: Text(
            "لا توجد تقييمات بعد",
            style: AppTextStyles.subHeading,
          ),
        );
    }
  }

  Widget _buildIngredients(RecipeDetailModel recipe) {
    return Column(
      children: recipe.ingredients.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.recipeCardGreen,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Text(
                item.quantity,
                style: AppTextStyles.text14_400,
              ),
              const Spacer(),
              Text(
                item.name,
                style: AppTextStyles.title,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSteps(RecipeDetailModel recipe) {
    return Column(
      children: recipe.steps.map((step) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.recipeCardGreen,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              CircleAvatar(
                child: Text(step.order.toString()),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  step.description,
                  style: AppTextStyles.text14_400,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
