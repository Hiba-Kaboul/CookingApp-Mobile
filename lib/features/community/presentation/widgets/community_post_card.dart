import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/features/community/presentation/widgets/comments_bottom_sheet.dart';
import 'package:project2/features/recipe_detail/data/api/recipe_detail_api.dart';
import 'package:project2/features/recipe_detail/data/models/recipe_detail_model.dart';
import 'package:project2/features/recipe_detail/presentation/bloc/recipe_detail_bloc.dart';
import 'package:project2/features/recipe_detail/presentation/pages/recipe_detail_page.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/api/comment_api.dart';
import '../../data/api/delete_comment_api.dart';
import '../../data/api/list_comments_api.dart';
import '../../data/model/users_model.dart';
import '../bloc/bloc_user_posts/users_posts_bloc.dart';
import '../bloc/bloc_user_posts/users_posts_state.dart';
import '../bloc/bloc_comment_posts/comment_posts_bloc.dart';
import '../bloc/bloc_delete_comment_posts/delete_comment_bloc.dart';
import '../bloc/bloc_delete_post/delete_users_posts_bloc.dart';
import '../bloc/bloc_liked_posts/likeed_unliked_posts_bloc.dart';
import '../bloc/bloc_liked_posts/likeed_unliked_posts_event.dart';
import '../bloc/bloc_saved_posts/saved_unsaved_posts_bloc.dart';
import '../bloc/bloc_saved_posts/saved_unsaved_posts_event.dart';
import '../bloc/lists_comments_post/lists_comments_bloc.dart';
import 'media_widgets.dart';
import 'postoptionsbottomsheet.dart';

class CommunityPostCard extends StatelessWidget {
  final String userName;
  final int postId;
  final String timeAgo;
  final String content;
  final int viewsCount;
  final List<MediaModel> mediaList;
  final String? avatar;
  final PostModel post; // ✅ هاد بس يلي رح نعتمد عليه للتفاعلات

  const CommunityPostCard({
    super.key,
    required this.userName,
    required this.postId,
    required this.timeAgo,
    required this.content,
    required this.mediaList,
    required this.avatar,
    required this.post,
    required this.viewsCount,
   
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 1. الرأس: صورة المستخدم والاسم
          ListTile(
              leading: CircleAvatar(
                backgroundImage: avatar != null ? NetworkImage(avatar!) : null,
                child: avatar == null ? const Icon(Icons.person) : null,
              ),
              title: Text(userName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(timeAgo),
              trailing: IconButton(
                onPressed: () {
                  final currentBloc = context.read<DeleteUsersPostsBloc>();
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return BlocProvider.value(
                        value: currentBloc,
                        child: PostOptionsBottomSheet(postId: postId),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.more_vert),
              )),

          Stack(
            children: [
              // 2. الجسم: مكان عرض الميديا
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: PostMediaWidget(media: mediaList),
                ),
              ),
            ],
          ),

          // 3. المحتوى والنص
        Padding(
  padding: const EdgeInsets.only(bottom: 10, right: 20.0, top: 5),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.end, // لضمان ذهاب العناصر للجهة اليمنى (حسب رغبتك)
    children: [
      Text(
        content, 
        textAlign: TextAlign.right,
      ),
      const SizedBox(width: 10), // مسافة بسيطة بين النص والزر
      TextButton(
        onPressed: () {
 Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => RecipeDetailBloc(RecipeDetailApi()),
          child: RecipeDetailPage(
              id: post.id,
          ),
        ),
      ),
    );        },
        child: const Text("المزيد.."), // النص الخاص بالزر
      ),
    ],
  ),
),

          // 4. التذييل: التفاعل
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: BlocBuilder<UsersPostsBloc, UsersPostsState>(
              buildWhen: (previous, current) => current is UsersPostsSuccess,
              builder: (context, state) {
                // نجيب أحدث نسخة من نفس البوست، أو نستخدم القديمة إذا ما لقيناها
                final currentPost = (state is UsersPostsSuccess)
                    ? state.posts.firstWhere(
                        (p) => p.id == post.id,
                        orElse: () => post,
                      )
                    : post;

                return Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read<LikeUnlikePostsBloc>().add(
                              ToggleLikePostEvent(postId),
                            );
                      },
                      icon: Icon(
                        currentPost.isLiked
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: currentPost.isLiked
                            ? AppColors.primary
                            : AppColors.grey,
                      ),
                    ),
                    Text("${currentPost.likesCount}"),
                    const SizedBox(width: 10),

                    IconButton(
                      onPressed: () {
                        final usersPostsBloc = context.read<UsersPostsBloc>();

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                    create: (context) =>
                                        CommentPostsBloc(CommentApi())),
                                BlocProvider(
                                    create: (context) =>
                                        GetCommentsBloc(GetCommentsApi())),
                                BlocProvider(
                                    create: (context) =>
                                        DeleteCommentBloc(DeleteCommentApi())),
                                BlocProvider.value(value: usersPostsBloc),
                              ],
                              child: CommentsBottomSheet(postId: postId),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.chat_bubble_outline,
                          color: AppColors.grey),
                    ),
                    Text(
                        "${currentPost.commentsCount}"), // 👈 صار بمكانه الصحيح جنب أيقونته
                    const SizedBox(width: 10),

                    const Icon(Icons.remove_red_eye_outlined,
                        color: AppColors.grey),
                    const SizedBox(width: 5),
                    Text("$viewsCount"),
                    const SizedBox(width: 10),

                    const Icon(Icons.share, color: AppColors.grey),
                    const Spacer(),

                    IconButton(
                      onPressed: () {
                        context.read<SaveUnlikePostsBloc>().add(
                              ToggleSavePostEvent(postId),
                            );
                      },
                      icon: Icon(
                        currentPost.isSaved
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
