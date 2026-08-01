abstract class DeleteRecipeCommentState {}

class DeleteRecipeCommentInitial extends DeleteRecipeCommentState {}

class DeleteRecipeCommentLoading extends DeleteRecipeCommentState {
  final int commentId; // حتى نعرف أي تعليق بالتحديد عم يحذف (لعرض لودينغ عليه بس)
  DeleteRecipeCommentLoading(this.commentId);
}

class DeleteRecipeCommentSuccess extends DeleteRecipeCommentState {
  final int commentId;
  DeleteRecipeCommentSuccess(this.commentId);
}

class DeleteRecipeCommentError extends DeleteRecipeCommentState {
  final String message;
  DeleteRecipeCommentError(this.message);
}