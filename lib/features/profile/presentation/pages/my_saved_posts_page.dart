import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/core/constants/app_colors.dart';

import '../../../admin_recipe_detail/data/api/admin_recipe_detail_api.dart';
import '../../../admin_recipe_detail/presentation/bloc/admin_recipe_detail_bloc.dart';
import '../../../admin_recipe_detail/presentation/pages/admin_recipe_detail_page.dart';
import '../../../recipe_detail/data/api/recipe_detail_api.dart';
import '../../../recipe_detail/presentation/bloc/recipe_detail_bloc.dart';
import '../../../recipe_detail/presentation/pages/recipe_detail_page.dart';
import '../bloc_my_saved_posts.dart/saved_posts_bloc.dart';
import '../bloc_my_saved_posts.dart/saved_posts_state.dart';

class SavedItemsPage extends StatelessWidget {
  const SavedItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedItemsBloc, SavedItemsState>(
      builder: (context, state) {
        if (state is SavedItemsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is SavedItemsError) {
          return Center(
            child: Text(state.message),
          );
        }

        if (state is SavedItemsSuccess) {
          if (state.items.isEmpty) {
            return const Center(
              child: Text("لا يوجد عناصر محفوظة"),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(2),
            itemCount: state.items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemBuilder: (context, index) {
              final item = state.items[index];
              final cover = item.coverMedia;

              return GestureDetector(
                onTap: () {
                  if (item.isRecipe) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) =>
                              AdminRecipeDetailBloc(AdminRecipeDetailApi()),
                          child: AdminRecipeDetailPage(id: item.id),
                        ),
                      ),
                    );
                  } else {
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
                },
                child: Container(
                    child: Container(
                  color: Colors.grey.shade200,
                  child: cover == null
                      ? const Icon(Icons.image)
                      : Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: cover.isVideo
                                    ? Container(
                                        color: AppColors.textDark,
                                        child: const Icon(
                                          Icons.play_circle_fill,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      )
                                    : Image.network(
                                        cover.url,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.broken_image),
                                      ),
                              ),
                            ),

                            // إشارة إنستغرام عند وجود أكثر من صورة/فيديو
                            if (item.hasMultipleMedia)
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.45),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Icon(
                                    Icons.collections,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),

                            // شارة النوع
                            Positioned(
                              top: 6,
                              left: 6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.85),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item.isRecipe ? "وصفة" : "منشور",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                )),
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
