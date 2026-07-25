abstract class GetCommentsEvent {}

class FetchCommentsEvent extends GetCommentsEvent {
  final int postId;

  FetchCommentsEvent(this.postId);
}

class LoadMoreCommentsEvent extends GetCommentsEvent {
  final int postId;

  LoadMoreCommentsEvent(this.postId);
}

// جوا get_comments_event.dart
class RemoveCommentLocallyEvent extends GetCommentsEvent {
  final int commentId;
  RemoveCommentLocallyEvent(this.commentId);
}