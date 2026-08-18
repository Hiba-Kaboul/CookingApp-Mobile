import 'package:project2/features/community/data/model/recipe_model.dart';

abstract class RecipeState {}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<RecipeModel> recipes;

  RecipeLoaded(this.recipes);
}

class RecipeError extends RecipeState {
  final String message;

  RecipeError(this.message);
}
