import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/features/admin_recipe_detail/data/api/admin_recipe_detail_api.dart';
import 'package:project2/features/admin_recipe_detail/presentation/bloc/admin_recipe_detail_bloc.dart';
import 'package:project2/features/admin_recipe_detail/presentation/pages/admin_recipe_detail_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/api/add_recipe_comment_api.dart';
import '../../data/api/delete_recipe_comment_api.dart';
import '../../data/api/get_recipe_comments_api.dart';
import '../../data/model/recipe_posts_model.dart';
import '../../data/model/users_model.dart';
import '../bloc/bloc_comment_recipe/add_recipe_comment_bloc.dart';
import '../bloc/bloc_delete_comment_recipe/delete_recipe_comment_bloc.dart';
import '../bloc/bloc_homepage_posts/recipes_bloc.dart';
import '../bloc/bloc_homepage_posts/recipes_event.dart';
import '../bloc/bloc_homepage_posts/recipes_state.dart';
import '../bloc/bloc_delete_post/delete_users_posts_bloc.dart';
import '../bloc/bloc_liked_recipes/like_recipe_bloc.dart';
import '../bloc/bloc_liked_recipes/like_recipe_event.dart';
import '../bloc/bloc_liked_recipes/like_recipe_state.dart';
import '../bloc/bloc_saved_recipes/save_recipe_bloc.dart';
import '../bloc/bloc_saved_recipes/save_recipe_event.dart';
import '../bloc/bloc_saved_recipes/save_recipe_state.dart';
import '../bloc/bloc_share_recipe/share_recipe_bloc.dart';
import '../bloc/bloc_share_recipe/share_recipe_event.dart';
import '../bloc/bloc_share_recipe/share_recipe_state.dart';
import '../bloc/lists_commenys_recipe/get_recipe_comments_bloc.dart';
import 'media_widgets.dart';
import 'postoptionsbottomsheet.dart';
import 'recipe_comments_bottom_sheet.dart';

class RecipePostCard extends StatelessWidget {
  final String userName;
  final int postId;
  final String timeAgo;
  final String content;
  final List<RecipeMedia> mediaList;
  final String? avatar;
  final Recipe recipe;

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
    return BlocListener<ShareRecipeBloc, ShareRecipeState>(
      listener: (context, state) async {
        if (state is ShareRecipeSuccess && state.recipeId == recipe.id) {
          if (state.platform == 'whatsapp') {
            final uri = Uri.parse(state.data.whatsappUrl);
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else if (state.platform == 'telegram') {
            final uri = Uri.parse(state.data.telegramUrl);
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else if (state.platform == 'copy_link') {
            await Clipboard.setData(
              ClipboardData(text: state.data.deepLink),
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم نسخ الرابط بنجاح')),
            );
          }
        }

        if (state is ShareRecipeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Card(
        elevation: 10,
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    avatar != null ? NetworkImage(avatar!) : null,
                child: avatar == null ? const Icon(Icons.person) : null,
              ),
              title: Text(
                userName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: PostMediaWidget(
                      media: mediaList
                          .map(
                            (m) => MediaModel(
                              id: m.id,
                              type: m.type,
                              url: m.url,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
                right: 20.0,
                left: 20.0,
                top: 5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    content,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.otpNotReceived,
                  ),
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) =>
                                AdminRecipeDetailBloc(AdminRecipeDetailApi()),
                            child: AdminRecipeDetailPage(
                              id: recipe.id,
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "المزيد..",
                      style: AppTextStyles.otpNotReceived,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: MultiBlocListener(
                listeners: [
                  BlocListener<LikeRecipeBloc, LikeRecipeState>(
                    listener: (context, state) {
                      if (state is LikeRecipeSuccess &&
                          state.recipeId == recipe.id) {
                        context.read<RecipesBloc>().add(
                              UpdateRecipeLikeEvent(
                                recipeId: state.recipeId,
                                isLiked: state.liked,
                                likesCount: state.likesCount,
                              ),
                            );
                      }
                    },
                  ),
                  BlocListener<SaveRecipeBloc, SaveRecipeState>(
                    listener: (context, state) {
                      if (state is SaveRecipeSuccess &&
                          state.recipeId == recipe.id) {
                        context.read<RecipesBloc>().add(
                              UpdateRecipeSaveEvent(
                                recipeId: state.recipeId,
                                isSaved: state.saved,
                              ),
                            );
                      }
                    },
                  ),
                ],
                child: BlocBuilder<RecipesBloc, RecipesState>(
                  buildWhen: (previous, current) => current is RecipesSuccess,
                  builder: (context, state) {
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
                            context.read<LikeRecipeBloc>().add(
                                  ToggleLikeRecipeEvent(recipe.id),
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
                        // const SizedBox(width: 5),
                        Text("${currentRecipe.likesCount}"),
                        // const SizedBox(width: 20),
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
                                    BlocProvider.value(
                                      value: recipesBloc,
                                    ),
                                    BlocProvider(
                                      create: (_) => AddRecipeCommentBloc(
                                        AddRecipeCommentApi(),
                                      ),
                                    ),
                                    BlocProvider(
                                      create: (_) => GetRecipeCommentsBloc(
                                        GetRecipeCommentsApi(),
                                      ),
                                    ),
                                    BlocProvider(
                                      create: (_) => DeleteRecipeCommentBloc(
                                        DeleteRecipeCommentApi(),
                                      ),
                                    ),
                                  ],
                                  child: RecipeCommentsBottomSheet(
                                    recipeId: recipe.id,
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.chat_bubble_outline,
                            color: AppColors.grey,
                          ),
                        ),
                        // const SizedBox(width: 5),
                        Text("${currentRecipe.commentsCount}"),
                        // const SizedBox(width: 20),
                        IconButton(
                          onPressed: () {
                            _showShareSheet(context, recipe.id);
                          },
                          icon: const Icon(
                            Icons.share,
                            color: AppColors.grey,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            context.read<SaveRecipeBloc>().add(
                                  ToggleSaveRecipeEvent(recipe.id),
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
            ),
          ],
        ),
      ),
    );
  }
}

void _showShareSheet(BuildContext context, int recipeId) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
    ),
    builder: (_) {
      return BlocProvider.value(
        value: context.read<ShareRecipeBloc>(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'مشاركة عبر',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.chat),
                title: const Text('واتساب'),
                onTap: () {
                  context.read<ShareRecipeBloc>().add(
                        ShareRecipeSubmitted(
                          recipeId: recipeId,
                          platform: 'whatsapp',
                        ),
                      );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.send),
                title: const Text('تيليجرام'),
                onTap: () {
                  context.read<ShareRecipeBloc>().add(
                        ShareRecipeSubmitted(
                          recipeId: recipeId,
                          platform: 'telegram',
                        ),
                      );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.link),
                title: const Text('نسخ الرابط'),
                onTap: () {
                  context.read<ShareRecipeBloc>().add(
                        ShareRecipeSubmitted(
                          recipeId: recipeId,
                          platform: 'copy_link',
                        ),
                      );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}