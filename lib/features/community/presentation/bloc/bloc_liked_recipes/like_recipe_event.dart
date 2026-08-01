abstract class LikeRecipeEvent {}

class ToggleLikeRecipeEvent extends LikeRecipeEvent {
  final int recipeId;
  ToggleLikeRecipeEvent(this.recipeId);
}