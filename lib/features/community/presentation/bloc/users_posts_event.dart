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
