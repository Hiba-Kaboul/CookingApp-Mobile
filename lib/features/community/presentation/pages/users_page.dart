import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../bloc/users_posts_bloc.dart';
import '../bloc/users_posts_event.dart';
import '../bloc/users_posts_state.dart';
import '../bloc_delete_post/delete_users_posts_bloc.dart';
import '../bloc_delete_post/delete_users_posts_state.dart';
import '../bloc_liked_posts/likeed_unliked_posts_bloc.dart';
import '../bloc_liked_posts/likeed_unliked_posts_state.dart';
import '../bloc_saved_posts/saved_unsaved_posts_bloc.dart';
import '../bloc_saved_posts/saved_unsaved_posts_state.dart';
import '../widgets/community_post_card.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // نطلب الصفحة الأولى عند فتح الصفحة
    context.read<UsersPostsBloc>().add(GetUsersPostsEvent());

    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      // نطلب المزيد من البيانات
      context.read<UsersPostsBloc>().add(LoadMorePostsEvent());
    }
  }

  @override
  void dispose() {
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
                "مجتمع المستخدمين",
                style: AppTextStyles.appBarTitle,
              ),
            ),
          ),
        ),
        body: BlocListener<DeleteUsersPostsBloc, DeleteUsersPostsState>(
          listener: (context, state) {
            if (state is DeleteUsersPostsSuccess) {
              context.read<UsersPostsBloc>().add(GetUsersPostsEvent());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("تم الحذف بنجاح")),
              );
            }
          },
          child: BlocBuilder<UsersPostsBloc, UsersPostsState>(
            builder: (context, state) {
              if (state is UsersPostsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is UsersPostsError) {
                return Center(child: Text(state.message));
              }

              if (state is UsersPostsSuccess) {
                final posts = state.posts;

                return ListView.builder(
                  controller: scrollController,
                  itemCount: posts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == posts.length) {
                      if (state.hasMore) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                              child: Text("لقد وصلت إلى نهاية المنشورات")),
                        );
                      }
                    }
                    final post = posts[index];
return MultiBlocListener(
    listeners: [
      // استماع للـ Like
      BlocListener<LikeUnlikePostsBloc, LikeUnlikePostsState>(
        listener: (context, state) {
          if (state is LikeUnlikePostsSuccess) {
            context.read<UsersPostsBloc>().add(
              UpdatePostLikeEvent(
                postId: state.postId,
                isLiked: state.liked,
                likesCount: state.likesCount,
              ),
            );
          }
        },
      ),
      // 2. أضف الاستماع للـ Save هنا
      BlocListener<SaveUnlikePostsBloc, SaveUnlikePostsState>(
        listener: (context, state) {
          if (state is SaveUnlikePostsSuccess) {
            // أرسل حدثاً لـ UsersPostsBloc لتحديث حالة الحفظ في القائمة
            context.read<UsersPostsBloc>().add(
              UpdatePostSaveEvent( // تأكد من إنشاء هذا الحدث في UsersPostsBloc
                postId: state.postId,
                isSaved: state.isSaved,
              ),
            );
          }
        },
      ),
    ],
    child: CommunityPostCard(
      postId: post.id,
     // ستتحدث هذه القيمة بعد إرسال الحدث أعلاه
      userName: post.user.name,
      avatar: post.user.avatar,
      content: post.description ?? "",
      mediaList: post.media,
        post: post,
      timeAgo: "",
    ),
  );
},
                );
              }
              return const SizedBox();
            },
          ),
        ));
  }
}
