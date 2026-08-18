import '../../../data/model/recipe_posts_model.dart';

abstract class RecipesState {}

class RecipesInitial extends RecipesState {}

class RecipesLoading extends RecipesState {}

class RecipesError extends RecipesState {
  final String message;
  RecipesError(this.message);
}

class RecipesSuccess extends RecipesState {
  final List<Recipe> recipes;
  final bool hasMore;
  final int currentPage;

  RecipesSuccess({
    required this.recipes,
    required this.hasMore,
    required this.currentPage,
  });
}