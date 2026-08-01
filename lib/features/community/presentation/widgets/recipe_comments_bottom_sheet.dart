import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/model/recipe_comments_list_model.dart';
import '../bloc/bloc_homepage_posts/recipes_bloc.dart';
import '../bloc/bloc_homepage_posts/recipes_event.dart';
import '../bloc/bloc_homepage_posts/recipes_state.dart';
import '../bloc/bloc_comment_recipe/add_recipe_comment_bloc.dart';
import '../bloc/bloc_comment_recipe/add_recipe_comment_event.dart';
import '../bloc/bloc_comment_recipe/add_recipe_comment_state.dart';
import '../bloc/bloc_delete_comment_recipe/delete_recipe_comment_bloc.dart';
import '../bloc/bloc_delete_comment_recipe/delete_recipe_comment_event.dart';
import '../bloc/bloc_delete_comment_recipe/delete_recipe_comment_state.dart';
import '../bloc/lists_commenys_recipe/get_recipe_comments_bloc.dart';
import '../bloc/lists_commenys_recipe/get_recipe_comments_event.dart';
import '../bloc/lists_commenys_recipe/get_recipe_comments_state.dart';
import 'time_translator.dart';

class RecipeCommentsBottomSheet extends StatefulWidget {
  final int recipeId;
  const RecipeCommentsBottomSheet({super.key, required this.recipeId});

  @override
  State<RecipeCommentsBottomSheet> createState() =>
      _RecipeCommentsBottomSheetState();
}

class _RecipeCommentsBottomSheetState extends State<RecipeCommentsBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context
        .read<GetRecipeCommentsBloc>()
        .add(FetchRecipeCommentsEvent(widget.recipeId));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        context
            .read<GetRecipeCommentsBloc>()
            .add(LoadMoreRecipeCommentsEvent(widget.recipeId));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, sheetScrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "التعليقات",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const Divider(height: 1),

              // ✅ لائحة التعليقات
              Expanded(
                child:
                    BlocListener<AddRecipeCommentBloc, AddRecipeCommentState>(
                  listener: (context, state) {
                    if (state is AddRecipeCommentSuccess) {
                      _controller.clear();
                      FocusScope.of(context).unfocus();

                      final recipesBloc = context.read<RecipesBloc>();
                      final recipesState = recipesBloc.state;

                      if (recipesState is RecipesSuccess) {
                        final recipe = recipesState.recipes.firstWhere(
                          (r) => r.id == widget.recipeId,
                        );

                        recipesBloc.add(
                          UpdateRecipeCommentsEvent(
                            recipeId: widget.recipeId,
                            commentsCount: recipe.commentsCount + 1,
                          ),
                        );
                      }

                      context.read<GetRecipeCommentsBloc>().add(
                            AddCommentLocallyEvent(
                              RecipeCommentItem(
                                id: state.comment.id,
                                body: state.comment.body,
                                user: RecipeCommentUser(
                                  id: state.comment.user.id,
                                  name: state.comment.user.name,
                                  avatar: state.comment.user.avatar,
                                ),
                                createdAt: state.comment.createdAt,
                              ),
                            ),
                          );
                    } else if (state is AddRecipeCommentFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  child: BlocBuilder<GetRecipeCommentsBloc,
                      GetRecipeCommentsState>(
                    builder: (context, state) {
                      if (state is GetRecipeCommentsLoading ||
                          state is GetRecipeCommentsInitial) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is GetRecipeCommentsError) {
                        return Center(child: Text(state.message));
                      }

                      final s = state as GetRecipeCommentsSuccess;
                      final comments = s.comments;

                      if (comments.isEmpty) {
                        return const Center(child: Text("لا يوجد تعليقات بعد"));
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: comments.length + (s.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= comments.length) {
                            return const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return _RecipeCommentTile(
                            comment: comments[index],
                            recipeId: widget.recipeId,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              const Divider(height: 1),

              // ✅ شريط كتابة التعليق
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            hintText: "اكتب تعليق...",
                            hintTextDirection: TextDirection.rtl,
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      BlocBuilder<AddRecipeCommentBloc, AddRecipeCommentState>(
                        builder: (context, state) {
                          final isLoading = state is AddRecipeCommentLoading;
                          return IconButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    final text = _controller.text.trim();
                                    if (text.isEmpty) return;
                                    context.read<AddRecipeCommentBloc>().add(
                                          SubmitRecipeCommentEvent(
                                            recipeId: widget.recipeId,
                                            body: text,
                                          ),
                                        );
                                  },
                            icon: isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : const Icon(Icons.send,
                                    color: AppColors.primary),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RecipeCommentTile extends StatelessWidget {
  final RecipeCommentItem comment;
  final int recipeId;

  const _RecipeCommentTile({required this.comment, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteRecipeCommentBloc, DeleteRecipeCommentState>(
      listener: (context, state) {
        if (state is DeleteRecipeCommentSuccess &&
            state.commentId == comment.id) {
          context
              .read<GetRecipeCommentsBloc>()
              .add(RemoveRecipeCommentLocallyEvent(comment.id));

          final recipesBloc = context.read<RecipesBloc>();
          final recipesState = recipesBloc.state;

          if (recipesState is RecipesSuccess) {
            final recipe = recipesState.recipes.firstWhere(
              (r) => r.id == recipeId,
            );

            recipesBloc.add(
              UpdateRecipeCommentsEvent(
                recipeId: recipeId,
                commentsCount:
                    recipe.commentsCount > 0 ? recipe.commentsCount - 1 : 0,
              ),
            );
          }
        } else if (state is DeleteRecipeCommentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 65,
              child: Text(
                translateTimeAgo(comment.createdAt),
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: comment.user.avatar != null
                            ? NetworkImage(comment.user.avatar!)
                            : null,
                        child: comment.user.avatar == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment.user.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(comment.body, textAlign: TextAlign.right),
                          ],
                        ),
                      ),
                      // ✅ زر الحذف
                      BlocBuilder<DeleteRecipeCommentBloc,
                          DeleteRecipeCommentState>(
                        builder: (context, state) {
                          final isDeleting =
                              state is DeleteRecipeCommentLoading &&
                                  state.commentId == comment.id;

                          if (isDeleting) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 14,
                                height: 14,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          }

                          return IconButton(
                            icon: const Icon(Icons.delete_outline,
                                size: 18, color: Colors.grey),
                            onPressed: () {
                              _confirmDelete(context);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("حذف التعليق"),
          content: const Text("متأكد إنك بدك تحذف هالتعليق؟"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("إلغاء"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<DeleteRecipeCommentBloc>().add(
                      DeleteRecipeCommentRequested(comment.id),
                    );
              },
              child: const Text("حذف", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
