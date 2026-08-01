abstract class UsersPostsEvent {}

class GetUsersPostsEvent extends UsersPostsEvent {}

class LoadMorePostsEvent extends UsersPostsEvent {}

class UpdatePostLikeEvent extends UsersPostsEvent {
  final int postId;
  final bool isLiked;
  final int likesCount;

  UpdatePostLikeEvent({
    required this.postId,
    required this.isLiked,
    required this.likesCount,
  });
}

class UpdatePostSaveEvent extends UsersPostsEvent {
  final int postId;
  final bool isSaved;

  UpdatePostSaveEvent({
    required this.postId,
    required this.isSaved,
  });
}

class UpdatePostCommentCountEvent extends UsersPostsEvent {
  final int postId;

  UpdatePostCommentCountEvent({required this.postId});
}


// جوا users_posts_event.dart
class DecrementPostCommentCountEvent extends UsersPostsEvent {
  final int postId;
  DecrementPostCommentCountEvent({required this.postId});
}