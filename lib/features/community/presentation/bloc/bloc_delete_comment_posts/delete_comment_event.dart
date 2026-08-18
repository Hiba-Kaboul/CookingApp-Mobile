abstract class DeleteCommentEvent {}

class DeleteCommentRequested extends DeleteCommentEvent {
  final int commentId;

  DeleteCommentRequested(this.commentId);
}

