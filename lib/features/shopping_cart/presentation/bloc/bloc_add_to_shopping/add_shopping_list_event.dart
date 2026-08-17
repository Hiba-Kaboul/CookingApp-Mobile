// presentation/bloc/bloc_add_to_shopping_list/add_to_shopping_list_event.dart
abstract class AddToShoppingListEvent {}

class AddIngredientsToShoppingList extends AddToShoppingListEvent {
  final List<int> ingredientIds;
  AddIngredientsToShoppingList(this.ingredientIds);
}