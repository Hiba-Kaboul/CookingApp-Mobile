import '../../../data/model/comment_model.dart';

abstract class CommentPostsState {}

class CommentsPostsInitial extends CommentPostsState {}

class CommentsPostsLoading extends CommentPostsState {}

class CommentsPostsSuccess extends CommentPostsState {
  final CommentModel comment;

  CommentsPostsSuccess(this.comment);
}

class CommentsPostsError extends CommentPostsState {
  final String message;

  CommentsPostsError(this.message);
}