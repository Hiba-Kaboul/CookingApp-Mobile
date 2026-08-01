import '../../../community/data/model/search_post_model.dart';


abstract class SavedPostsState {}

class SavedPostsInitial extends SavedPostsState {}

class SavedPostsLoading extends SavedPostsState {}

class SavedPostsError extends SavedPostsState {
  final String message;
  SavedPostsError(this.message);
}

class SavedPostsSuccess extends SavedPostsState {
  final List<Post> posts;
  final bool hasMore;
  final int currentPage;

  SavedPostsSuccess({
    required this.posts,
    required this.hasMore,
    required this.currentPage,
  });
}