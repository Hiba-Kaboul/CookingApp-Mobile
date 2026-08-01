abstract class DeleteCommentState {}

class DeleteCommentInitial extends DeleteCommentState {}

class DeleteCommentLoading extends DeleteCommentState {
  final int commentId; // حتى نعرف أي تعليق بالضبط عم يتحذف (لعرض لودينغ عليه بس)
  DeleteCommentLoading(this.commentId);
}

class DeleteCommentSuccess extends DeleteCommentState {
  final int commentId;
  DeleteCommentSuccess(this.commentId);
}

class DeleteCommentError extends DeleteCommentState {
  final String message;
  DeleteCommentError(this.message);
}