import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/core/constants/app_colors.dart';

import '../bloc_my_saved_posts.dart/saved_posts_bloc.dart';
import '../bloc_my_saved_posts.dart/saved_posts_event.dart';
import '../bloc_my_saved_posts.dart/saved_posts_state.dart';
class SavedPostsPage extends StatefulWidget {
  const SavedPostsPage({super.key});

  @override
  State<SavedPostsPage> createState() => _SavedPostsPageState();
}

class _SavedPostsPageState extends State<SavedPostsPage> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      if (controller.position.pixels >=
          controller.position.maxScrollExtent - 200) {
        context.read<SavedPostsBloc>().add(
              LoadMoreSavedPostsEvent(),
            );
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedPostsBloc, SavedPostsState>(
      builder: (context, state) {
        if (state is SavedPostsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is SavedPostsError) {
          return Center(
            child: Text(state.message),
          );
        }

        if (state is SavedPostsSuccess) {
          if (state.posts.isEmpty) {
            return const Center(
              child: Text("لا يوجد منشورات محفوظة"),
            );
          }

          return GridView.builder(
            controller: controller,
            padding: const EdgeInsets.all(2),
            itemCount: state.posts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemBuilder: (context, index) {
              final post = state.posts[index];

              return Container(
                color: Colors.grey.shade200,
                child: post.media.isEmpty
                    ? const Icon(Icons.image)
                    : Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                post.media.first.url,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (post.media.length > 1)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.textDark.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  Icons.layers,
                                  color: AppColors.otpGradientMiddle,
                                  size: 20,
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