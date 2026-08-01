abstract class SaveRecipeState {}

class SaveRecipeInitial extends SaveRecipeState {}

class SaveRecipeLoading extends SaveRecipeState {}

class SaveRecipeSuccess extends SaveRecipeState {
  final int recipeId;
  final bool saved;
  final int savesCount;

  SaveRecipeSuccess({
    required this.recipeId,
    required this.saved,
    required this.savesCount,
  });
}

class SaveRecipeFailure extends SaveRecipeState {
  final String message;
  SaveRecipeFailure(this.message);
}