import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/core/constants/app_text_styles.dart';
import 'package:project2/features/admin_recipe_detail/data/models/admin_recipe_detail_model.dart';
import 'package:project2/features/admin_recipe_detail/presentation/bloc/admin_recipe_detail_bloc.dart';
import 'package:project2/features/admin_recipe_detail/presentation/bloc/admin_recipe_detail_event.dart';
import 'package:project2/features/admin_recipe_detail/presentation/bloc/admin_recipe_detail_state.dart';
import 'package:project2/features/admin_recipe_detail/presentation/pages/smart_cooking_page.dart';
import 'package:project2/features/admin_recipe_detail/presentation/widget/admin_recipe_author_widget.dart';
import 'package:project2/features/admin_recipe_detail/presentation/widget/admin_recipe_bottom_button.dart';
import 'package:project2/features/admin_recipe_detail/presentation/widget/admin_recipe_header_widget.dart';
import 'package:project2/features/admin_recipe_detail/presentation/widget/admin_recipe_tabs_widget.dart';

class AdminRecipeDetailPage extends StatefulWidget {
  final int id;

  const AdminRecipeDetailPage({
    super.key,
    required this.id,
  });

  @override
  State<AdminRecipeDetailPage> createState() => _AdminRecipeDetailPageState();
}

class _AdminRecipeDetailPageState extends State<AdminRecipeDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdminRecipeDetailBloc>().add(GetAdminRecipeDetail(widget.id));
  }

  bool isFavorite = true;
  AdminRecipeTab selectedTab = AdminRecipeTab.ingredients;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocBuilder<AdminRecipeDetailBloc, AdminRecipeDetailState>(
        builder: (context, state) {
          if (state is AdminRecipeDetailLoading) {
            return const Scaffold(
              backgroundColor: AppColors.background,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is AdminRecipeDetailError) {
            return Scaffold(
              backgroundColor: AppColors.background,
              body: Center(
                child: Text(state.message),
              ),
            );
          }

          if (state is AdminRecipeDetailLoaded) {
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
                        AdminRecipeHeaderWidget(
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
                                recipe.name,
                                style: AppTextStyles.heading,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                recipe.description,
                                style: AppTextStyles.subHeading
                                    .copyWith(height: 1.6),
                              ),
                              const SizedBox(height: 18),
                              AdminRecipeAuthorWidget(
                                userName: recipe.userName,
                                userAvatar: recipe.userAvatar,
                              ),
                              const SizedBox(height: 18),
                              _buildStats(recipe),
                              const SizedBox(height: 20),
                              AdminRecipeTabsWidget(
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
                    child: AdminRecipeBottomButton(
                      onPressed: () {
                         Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SmartCookingPage(
          steps: recipe.steps,
          imageUrl:
              recipe.media.isNotEmpty ? recipe.media.first.url : '',
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

          return const Scaffold(
            backgroundColor: AppColors.background,
            body: SizedBox(),
          );
        },
      ),
    );
  }

  Widget _buildStats(AdminRecipeDetailModel recipe) {
    return Row(
      children: [
        Expanded(
          child: _statItem(
            Icons.signal_cellular_alt,
            recipe.difficulty,
          ),
        ),
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
            _formatDuration(recipe.prepTime),
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
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(AdminRecipeDetailModel recipe) {
    switch (selectedTab) {
      case AdminRecipeTab.ingredients:
        return _buildIngredients(recipe);
      case AdminRecipeTab.steps:
        return _buildSteps(recipe);
      case AdminRecipeTab.nutrition:
        return _buildNutrition(recipe);
    }
  }

  Widget _buildIngredients(AdminRecipeDetailModel recipe) {
    return Column(
      children: recipe.ingredients.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.recipeCardGreen,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              item,
              style: AppTextStyles.title,
              textAlign: TextAlign.right,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSteps(AdminRecipeDetailModel recipe) {
    return Column(
      children: List.generate(recipe.steps.length, (index) {
        final step = recipe.steps[index];
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
                child: Text("${index + 1}"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  step,
                  style: AppTextStyles.text14_400,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildNutrition(AdminRecipeDetailModel recipe) {
    final items = [
      {"label": "السعرات", "value": "${recipe.calories}"},
      {"label": "الكاربوهيدرات", "value": "${recipe.carbs} غ"},
      {"label": "البروتين", "value": "${recipe.protein} غ"},
      {"label": "الدهون", "value": "${recipe.fat} غ"},
    ];

    return Column(
      children: items.map((item) {
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
                item["value"]!,
                style: AppTextStyles.text14_400,
              ),
              const Spacer(),
              Text(
                item["label"]!,
                style: AppTextStyles.title,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
