abstract class SaveUnlikePostsState {}

class SaveUnlikePostsInitial extends SaveUnlikePostsState {}

class SaveUnlikePostsLoading extends SaveUnlikePostsState {}

class SaveUnlikePostsSuccess extends SaveUnlikePostsState {
  final int postId;
  final bool isSaved;
  final int savesCount;

  SaveUnlikePostsSuccess({
    required this.postId,
    required this.isSaved,
    required this.savesCount,
  });
}

class SaveUnlikePostsError extends SaveUnlikePostsState {
  final String message;

  SaveUnlikePostsError(this.message);
}