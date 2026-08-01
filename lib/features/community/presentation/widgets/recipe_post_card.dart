import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/features/community/presentation/widgets/comments_bottom_sheet.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/api/comment_api.dart';
import '../../data/api/delete_comment_api.dart';
import '../../data/api/list_comments_api.dart';
import '../../data/model/recipe_model.dart'; // تأكد من مسار نموذج الوصفات
import '../../data/model/users_model.dart';
import '../bloc_homepage_posts/recipes_bloc.dart'; // مسار الـ Bloc الخاص بالوصفات
import '../bloc_homepage_posts/recipes_state.dart'; // مسار الـ State الخاص بالوصفات
import '../bloc_comment_posts/comment_posts_bloc.dart';
import '../bloc_delete_comment_posts/delete_comment_bloc.dart';
import '../bloc_delete_post/delete_users_posts_bloc.dart';
import '../bloc_liked_posts/likeed_unliked_posts_bloc.dart';
import '../bloc_liked_posts/likeed_unliked_posts_event.dart';
import '../bloc_saved_posts/saved_unsaved_posts_bloc.dart';
import '../bloc_saved_posts/saved_unsaved_posts_event.dart';
import '../lists_comments_post/lists_comments_bloc.dart';
import 'media_widgets.dart';
import 'postoptionsbottomsheet.dart';

class RecipePostCard extends StatelessWidget {
  final String userName;
  final int postId;
  final String timeAgo;
  final String content;
  final List<RecipeMedia> mediaList;
  final String? avatar;
  final Recipe recipe; // ✅ اعتمدنا على Recipe هنا للتفاعلات

  const RecipePostCard({
    super.key,
    required this.userName,
    required this.postId,
    required this.timeAgo,
    required this.content,
    required this.mediaList,
    required this.avatar,
    required this.recipe,
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
            ),
          ),

          Stack(
            children: [
              // 2. الجسم: مكان عرض الميديا (تم تعديل الـ MediaModel إلى نوع متوافق مع RecipeMedia إذا تطلب الأمر، أو يتم تحويله)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: PostMediaWidget(
                    media: mediaList.map((m) => MediaModel(
                      id: m.id,
                      type: m.type,
                      url: m.url,
                      // order: m.order,
                    )).toList(),
                  ),
                ),
              ),
            ],
          ),

          // 3. المحتوى والنص
          Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 20.0, top: 5),
            child: Text(content, textAlign: TextAlign.right),
          ),

          // 4. التذييل: التفاعل
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: BlocBuilder<RecipesBloc, RecipesState>(
              buildWhen: (previous, current) => current is RecipesSuccess,
              builder: (context, state) {
                // نجيب أحدث نسخة من نفس الوصفة من الـ RecipesBloc
                final currentRecipe = (state is RecipesSuccess)
                    ? state.recipes.firstWhere(
                        (p) => p.id == recipe.id,
                        orElse: () => recipe,
                      )
                    : recipe;

                return Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read<LikeUnlikePostsBloc>().add(
                              ToggleLikePostEvent(postId),
                            );
                      },
                      icon: Icon(
                        currentRecipe.isLiked
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: currentRecipe.isLiked
                            ? AppColors.primary
                            : AppColors.grey,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text("${currentRecipe.likesCount}"),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () {
                        final recipesBloc = context.read<RecipesBloc>();

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (context) =>
                                      CommentPostsBloc(CommentApi()),
                                ),
                                BlocProvider(
                                  create: (context) =>
                                      GetCommentsBloc(GetCommentsApi()),
                                ),
                                BlocProvider(
                                  create: (context) =>
                                      DeleteCommentBloc(DeleteCommentApi()),
                                ),
                                BlocProvider.value(
                                  value: recipesBloc,
                                ),
                              ],
                              child: CommentsBottomSheet(postId: postId),
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.chat_bubble_outline,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text("${currentRecipe.commentsCount}"),
                    const SizedBox(width: 20),
                    const Icon(Icons.share, color: AppColors.grey),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        context.read<SaveUnlikePostsBloc>().add(
                              ToggleSavePostEvent(postId),
                            );
                      },
                      icon: Icon(
                        currentRecipe.isSaved
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