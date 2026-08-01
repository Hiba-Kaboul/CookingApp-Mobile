abstract class RecipeEvent {}

class GetRecipesEvent extends RecipeEvent {
  final int categoryId;

  GetRecipesEvent(this.categoryId);
}