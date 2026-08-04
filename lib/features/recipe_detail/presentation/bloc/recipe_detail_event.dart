abstract class RecipeDetailEvent {}

class GetRecipeDetail extends RecipeDetailEvent {
  final int id;

  GetRecipeDetail(this.id);
}