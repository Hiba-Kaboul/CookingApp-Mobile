import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/model/users_model.dart';
import '../bloc_delete_post/delete_users_posts_bloc.dart';
import '../bloc_liked_posts/likeed_unliked_posts_bloc.dart';
import '../bloc_liked_posts/likeed_unliked_posts_event.dart';
import '../bloc_saved_posts/saved_unsaved_posts_bloc.dart';
import '../bloc_saved_posts/saved_unsaved_posts_event.dart';
import 'media_widgets.dart';
import 'postoptionsbottomsheet.dart';

class CommunityPostCard extends StatelessWidget {
  final String userName;
  final int postId;
  final String timeAgo;
  final String content;
  final List<MediaModel> mediaList;
  final String? avatar;

  final int comments;
  final bool isLiked;
  final int likesCount;
  final bool isSaved;

  const CommunityPostCard({
    super.key,
    required this.userName,
    required this.postId,
    required this.timeAgo,
    required this.content,
    required this.mediaList,
    required this.avatar,
    required this.comments,
    required this.isLiked,
    required this.likesCount,
    required this.isSaved,
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
            child: Text(content, textAlign: TextAlign.right),
          ),

          // 4. التذييل: التفاعل
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    context.read<LikeUnlikePostsBloc>().add(
                          ToggleLikePostEvent(postId),
                        );
                  },
                  icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? AppColors.primary : AppColors.grey),
                ),
                const SizedBox(width: 5),
                Text("${likesCount}"),
                const SizedBox(width: 20),
                const Icon(Icons.chat_bubble_outline, color: AppColors.grey),
                const SizedBox(width: 5),
                Text("$comments"),
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
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved ? AppColors.grey
                     : AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
