import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/core/constants/app_colors.dart';

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

              return Container(
                color: Colors.grey.shade200,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: item.isVideo
                            ? Container(
                                color: AppColors.textDark,
                                child: const Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              )
                            : Image.network(
                                item.image,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    // شارة توضح نوع العنصر (وصفة أو منشور)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
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
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}