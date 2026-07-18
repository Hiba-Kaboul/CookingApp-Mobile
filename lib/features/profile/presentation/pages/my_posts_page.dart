import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/core/constants/app_colors.dart';

import '../bloc_my_approved_posts.dart/my_posts_bloc.dart';
import '../bloc_my_approved_posts.dart/my_posts_event.dart';
import '../bloc_my_approved_posts.dart/my_posts_state.dart';

class MyPostsPage extends StatefulWidget {
  const MyPostsPage({super.key});

  @override
  State<MyPostsPage> createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      if (controller.position.pixels >=
          controller.position.maxScrollExtent - 200) {
        context.read<MyPostsBloc>().add(
              LoadMoreMyPostsEvent(),
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
    return BlocBuilder<MyPostsBloc, MyPostsState>(
      builder: (context, state) {
        if (state is MyPostsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is MyPostsError) {
          return Center(
            child: Text(state.message),
          );
        }

        if (state is MyPostsSuccess) {
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
                        // 1. استخدمي Stack لوضع العناصر فوق بعضها
                        children: [
                          // الصورة الأساسية
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                post.media.first.url,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // 2. التحقق من وجود أكثر من صورة لإظهار الأيقونة
                          if (post.media.length > 1)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.textDark
                                      .withOpacity(0.5), // خلفية شبه شفافة
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  Icons.layers, // أو استخدمي Icons.collections
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
