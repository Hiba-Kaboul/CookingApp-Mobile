// presentation/bloc/bloc_search_recipes/search_recipes_state.dart
import '../../../data/model/recipe_model.dart';
import '../../../data/model/recipe_posts_model.dart';

abstract class SearchRecipesState {}

class SearchRecipesInitial extends SearchRecipesState {}

class SearchRecipesLoading extends SearchRecipesState {}

class SearchRecipesEmpty extends SearchRecipesState {}

class SearchRecipesError extends SearchRecipesState {
  final String message;
  SearchRecipesError(this.message);
}

class SearchRecipesLoaded extends SearchRecipesState {
  final List<Recipe> recipes;
  SearchRecipesLoaded(this.recipes);
}