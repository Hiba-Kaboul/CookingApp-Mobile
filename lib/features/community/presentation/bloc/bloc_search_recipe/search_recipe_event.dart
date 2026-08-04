// presentation/bloc/bloc_search_recipes/search_recipes_event.dart
abstract class SearchRecipesEvent {}

class SearchRecipesQueryChanged extends SearchRecipesEvent {
  final String query;
  SearchRecipesQueryChanged(this.query);
}