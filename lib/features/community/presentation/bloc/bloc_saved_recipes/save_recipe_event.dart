abstract class SaveRecipeEvent {}

class ToggleSaveRecipeEvent extends SaveRecipeEvent {
  final int recipeId;
  ToggleSaveRecipeEvent(this.recipeId);
}