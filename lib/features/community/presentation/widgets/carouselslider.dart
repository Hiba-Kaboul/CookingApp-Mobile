import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/core/constants/app_text_styles.dart';
import 'package:project2/features/admin_recipe_detail/data/api/admin_recipe_detail_api.dart';
import 'package:project2/features/admin_recipe_detail/presentation/bloc/admin_recipe_detail_bloc.dart';
import 'package:project2/features/admin_recipe_detail/presentation/pages/admin_recipe_detail_page.dart';
import 'package:project2/features/recipe_detail/data/api/recipe_detail_api.dart';
import 'package:project2/features/recipe_detail/presentation/bloc/recipe_detail_bloc.dart';
import 'package:project2/features/recipe_detail/presentation/pages/recipe_detail_page.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/model/trending_model.dart';
import '../bloc/bloc_trending/trending_bloc.dart';
import '../bloc/bloc_trending/trending_state.dart';

class Carouselslider extends StatelessWidget {
  const Carouselslider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: BlocBuilder<TrendingBloc, TrendingState>(
        builder: (context, state) {
          if (state is TrendingLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TrendingError || state is TrendingEmpty) {
            return const SizedBox.shrink();
          }

          if (state is! TrendingSuccess) {
            return const SizedBox.shrink();
          }

          final items = state.items;

          return CarouselSlider.builder(
            options: CarouselOptions(
              height: 170,
              autoPlay: items.length > 1,
              enlargeCenterPage: false,
              viewportFraction: 0.5,
              autoPlayInterval: const Duration(seconds: 1),
              padEnds: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 1000),
              enableInfiniteScroll: items.length > 1,
            ),
            itemCount: items.length,
            itemBuilder: (context, index, realIndex) {
              final item = items[index];
              return _TrendingCard(item: item);
            },
          );
        },
      ),
    );
  }
}

class _TrendingCard extends StatelessWidget {
  final TrendingItem item;

  const _TrendingCard({required this.item});

  bool get _isRecipe =>
      item.type.contains('recipe') ||
      (!item.type.contains('post') && item.durationMinutes > 0);

  void _openDetails(BuildContext context) {
    if (item.id == 0) return;

    if (_isRecipe) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AdminRecipeDetailBloc(AdminRecipeDetailApi()),
            child: AdminRecipeDetailPage(id: item.id),
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => RecipeDetailBloc(RecipeDetailApi()),
          child: RecipeDetailPage(id: item.id),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDetails(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 1),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                child: item.imageUrl.isEmpty
                    ? Image.asset(
                        "assets/images/onboarding1.png",
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                    : Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => Image.asset(
                          "assets/images/onboarding1.png",
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        item.title.isEmpty ? 'بدون عنوان' : item.title,
                        style: AppTextStyles.title,
                        maxLines: 1,
                      ),
                    ),
                    const Spacer(),
                    if (item.durationMinutes > 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "${item.durationMinutes} دقيقة",
                              textAlign: TextAlign.right,
                              style: AppTextStyles.title1,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: AppColors.light_brown,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
