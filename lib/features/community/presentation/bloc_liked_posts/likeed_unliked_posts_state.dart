
abstract class LikeUnlikePostsState {}

class LikeUnlikePostsInitial extends LikeUnlikePostsState {}

class LikeUnlikePostsLoading extends LikeUnlikePostsState {}

class LikeUnlikePostsSuccess extends LikeUnlikePostsState {
  final int postId;
  final bool liked;
  final int likesCount;

  LikeUnlikePostsSuccess({
    required this.postId,
    required this.liked,
    required this.likesCount,
  });
}

class LikeUnlikePostsError extends LikeUnlikePostsState {
  final String message;

  LikeUnlikePostsError(this.message);
}