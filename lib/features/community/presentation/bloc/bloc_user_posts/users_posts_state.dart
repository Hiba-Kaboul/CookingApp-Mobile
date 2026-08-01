import '../../../data/model/users_model.dart';

abstract class UsersPostsState {}

class UsersPostsInitial extends UsersPostsState {}

class UsersPostsLoading extends UsersPostsState {}

class UsersPostsSuccess extends UsersPostsState {
  final List<PostModel> posts; // القائمة المجمعة
  final bool hasMore;          // هل هناك صفحات إضافية؟
  final bool isLoadingMore;    // هل نقوم بتحميل صفحة إضافية الآن؟

  UsersPostsSuccess(this.posts, this.hasMore, {this.isLoadingMore = false});
}

class UsersPostsError extends UsersPostsState {
  final String message;

  UsersPostsError(this.message);
}