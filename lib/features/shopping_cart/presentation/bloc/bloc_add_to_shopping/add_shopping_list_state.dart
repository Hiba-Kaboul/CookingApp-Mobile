// presentation/bloc/bloc_add_to_shopping_list/add_to_shopping_list_state.dart
abstract class AddToShoppingListState {}

class AddToShoppingListInitial extends AddToShoppingListState {}

class AddToShoppingListLoading extends AddToShoppingListState {}

class AddToShoppingListSuccess extends AddToShoppingListState {
  final int addedCount;
  AddToShoppingListSuccess(this.addedCount);
}

class AddToShoppingListFailure extends AddToShoppingListState {
  final String message;
  AddToShoppingListFailure(this.message);
}