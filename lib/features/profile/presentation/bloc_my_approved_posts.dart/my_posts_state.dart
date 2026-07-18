import '../../../community/data/model/users_model.dart';

abstract class MyPostsState {}

class MyPostsInitial extends MyPostsState {}

class MyPostsLoading extends MyPostsState {}

class MyPostsSuccess extends MyPostsState {
  final List<PostModel> posts;
  final bool hasMore;

  MyPostsSuccess(this.posts, this.hasMore);
}

class MyPostsError extends MyPostsState {
  final String message;

  MyPostsError(this.message);
}