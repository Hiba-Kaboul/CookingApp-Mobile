import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/model/comments_list_model.dart';
import '../bloc/bloc_user_posts/users_posts_bloc.dart';
import '../bloc/bloc_user_posts/users_posts_event.dart';
import '../bloc/bloc_comment_posts/comment_posts_bloc.dart';
import '../bloc/bloc_comment_posts/comment_posts_event.dart';
import '../bloc/bloc_comment_posts/comment_posts_state.dart';
import '../bloc/bloc_delete_comment_posts/delete_comment_bloc.dart';
import '../bloc/bloc_delete_comment_posts/delete_comment_event.dart';
import '../bloc/bloc_delete_comment_posts/delete_comment_state.dart';
import '../bloc/lists_comments_post/lists_comments_bloc.dart';
import '../bloc/lists_comments_post/lists_comments_event.dart';
import '../bloc/lists_comments_post/lists_comments_state.dart';
import 'time_translator.dart';

class CommentsBottomSheet extends StatefulWidget {
  final int postId;
  const CommentsBottomSheet({super.key, required this.postId});

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<GetCommentsBloc>().add(FetchCommentsEvent(widget.postId));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        context
            .read<GetCommentsBloc>()
            .add(LoadMoreCommentsEvent(widget.postId));
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
                child: BlocListener<CommentPostsBloc, CommentPostsState>(
                  listener: (context, state) {
                    if (state is CommentsPostsSuccess) {
                      _controller.clear();
                      FocusScope.of(context).unfocus();

                      // تحديث عدّاد التعليقات بالبوست
                      context.read<UsersPostsBloc>().add(
                            UpdatePostCommentCountEvent(postId: widget.postId),
                          );

                      // ✅ إعادة جلب التعليقات حتى تظهر فورًا باللائحة
                      context.read<GetCommentsBloc>().add(
                            FetchCommentsEvent(widget.postId),
                          );
                    } else if (state is CommentsPostsError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  child: BlocBuilder<GetCommentsBloc, GetCommentsState>(
                    builder: (context, state) {
                      if (state is GetCommentsLoading ||
                          state is GetCommentsInitial) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is GetCommentsError) {
                        return Center(child: Text(state.message));
                      }

                      final s = state as GetCommentsSuccess;
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
                          return _CommentTile(comment: comments[index], postId: widget.postId);
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
                      BlocBuilder<CommentPostsBloc, CommentPostsState>(
                        builder: (context, state) {
                          final isLoading = state is CommentsPostsLoading;
                          return IconButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    final text = _controller.text.trim();
                                    if (text.isEmpty) return;
                                    context.read<CommentPostsBloc>().add(
                                          CommentOnPostsEvent(
                                              widget.postId, text),
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


class _CommentTile extends StatelessWidget {
  final CommentItemModel comment;
  final int postId;

  const _CommentTile({required this.comment, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteCommentBloc, DeleteCommentState>(
      listener: (context, state) {
        if (state is DeleteCommentSuccess && state.commentId == comment.id) {
          context.read<GetCommentsBloc>().add(RemoveCommentLocallyEvent(comment.id));
          context.read<UsersPostsBloc>().add(
                DecrementPostCommentCountEvent(postId: postId),
              );
        } else if (state is DeleteCommentError) {
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
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(comment.body, textAlign: TextAlign.right),
                          ],
                        ),
                      ),
                      // ✅ زر الحذف
                      BlocBuilder<DeleteCommentBloc, DeleteCommentState>(
                        builder: (context, state) {
                          final isDeleting = state is DeleteCommentLoading &&
                              state.commentId == comment.id;

                          if (isDeleting) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(strokeWidth: 2),
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
                context.read<DeleteCommentBloc>().add(
                      DeleteCommentRequested(comment.id),
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