abstract class RecipesEvent {}

class GetRecipesEvent extends RecipesEvent {}

class LoadMoreRecipesEvent extends RecipesEvent {}

class UpdateRecipeLikeEvent extends RecipesEvent {
  final int recipeId;
  final bool isLiked;
  final int likesCount;

  UpdateRecipeLikeEvent({
    required this.recipeId,
    required this.isLiked,
    required this.likesCount,
  });
}

class UpdateRecipeSaveEvent extends RecipesEvent {
  final int recipeId;
  final bool isSaved;

  UpdateRecipeSaveEvent({
    required this.recipeId,
    required this.isSaved,
  });
}

class UpdateRecipeCommentsEvent extends RecipesEvent {
  final int recipeId;
  final int commentsCount;

  UpdateRecipeCommentsEvent({
    required this.recipeId,
    required this.commentsCount,
  });
}