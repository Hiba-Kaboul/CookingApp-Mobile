import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/bloc_user_posts/users_posts_bloc.dart';
import '../bloc/bloc_user_posts/users_posts_event.dart';
import '../bloc/bloc_comment_posts/comment_posts_bloc.dart';
import '../bloc/bloc_comment_posts/comment_posts_event.dart';
import '../bloc/bloc_comment_posts/comment_posts_state.dart';
       // ✅ استيراد الـ Event تبعو

class AddCommentBar extends StatefulWidget {
  final int postId;
  const AddCommentBar({super.key, required this.postId});

  @override
  State<AddCommentBar> createState() => _AddCommentBarState();
}

class _AddCommentBarState extends State<AddCommentBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CommentPostsBloc, CommentPostsState>(
      listener: (context, state) {
        if (state is CommentsPostsSuccess) {
          // ✅ هون بالضبط - نبعت الـ event للبلوك المركزي حتى يزيد العداد
          context.read<UsersPostsBloc>().add(
                UpdatePostCommentCountEvent(postId: widget.postId),
              );

          _controller.clear();
          FocusScope.of(context).unfocus();
          Navigator.of(context).pop();
        } else if (state is CommentsPostsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    hintText: "اكتب تعليق...",
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
                                  CommentOnPostsEvent(widget.postId, text),
                                );
                          },
                    icon: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send, color: AppColors.primary),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}