import '../../../data/model/search_post_model.dart';

abstract class SearchPostsState {}

class SearchPostsInitial extends SearchPostsState {}

class SearchPostsLoading extends SearchPostsState {}

class SearchPostsLoaded extends SearchPostsState {
  final List<Post> posts;
  SearchPostsLoaded(this.posts);
}

class SearchPostsEmpty extends SearchPostsState {}

class SearchPostsError extends SearchPostsState {
  final String message;
  SearchPostsError(this.message);
}