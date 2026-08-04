import 'package:project2/features/recipe_detail/data/models/recipe_detail_model.dart';

abstract class RecipeDetailState {}

class RecipeDetailInitial extends RecipeDetailState {}

class RecipeDetailLoading extends RecipeDetailState {}

class RecipeDetailLoaded extends RecipeDetailState {
  final RecipeDetailModel recipe;

  RecipeDetailLoaded(this.recipe);
}

class RecipeDetailError extends RecipeDetailState {
  final String message;

  RecipeDetailError(this.message);
}