abstract class DeleteRecipeCommentEvent {}

class DeleteRecipeCommentRequested extends DeleteRecipeCommentEvent {
  final int commentId;
  DeleteRecipeCommentRequested(this.commentId);
}