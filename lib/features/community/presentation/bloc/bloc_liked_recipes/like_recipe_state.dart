abstract class LikeRecipeState {}

class LikeRecipeInitial extends LikeRecipeState {}

class LikeRecipeLoading extends LikeRecipeState {}

class LikeRecipeSuccess extends LikeRecipeState {
  final int recipeId;
  final bool liked;
  final int likesCount;

  LikeRecipeSuccess({
    required this.recipeId,
    required this.liked,
    required this.likesCount,
  });
}

class LikeRecipeFailure extends LikeRecipeState {
  final String message;
  LikeRecipeFailure(this.message);
}