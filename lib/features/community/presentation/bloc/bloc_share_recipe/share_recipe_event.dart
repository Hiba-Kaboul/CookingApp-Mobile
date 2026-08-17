abstract class ShareRecipeEvent {}

class ShareRecipeSubmitted extends ShareRecipeEvent {
  final int recipeId;
  final String platform;

  ShareRecipeSubmitted({
    required this.recipeId,
    required this.platform,
  });
}