abstract class AddRecipeCommentEvent {}

class SubmitRecipeCommentEvent extends AddRecipeCommentEvent {
  final int recipeId;
  final String body;

  SubmitRecipeCommentEvent({
    required this.recipeId,
    required this.body,
  });
}