import '../../../data/model/comments_list_model.dart';

abstract class GetCommentsState {}

class GetCommentsInitial extends GetCommentsState {}

class GetCommentsLoading extends GetCommentsState {}

class GetCommentsSuccess extends GetCommentsState {
  final List<CommentItemModel> comments;
  final bool hasMore;
  final bool isLoadingMore;

  GetCommentsSuccess(
    this.comments,
    this.hasMore, {
    this.isLoadingMore = false,
  });
}

class GetCommentsError extends GetCommentsState {
  final String message;

  GetCommentsError(this.message);
}