// presentation/bloc/bloc_shopping_list/shopping_list_state.dart
import '../../../data/model/shopping_item_model.dart';

abstract class ShoppingListState {}

class ShoppingListInitial extends ShoppingListState {}

class ShoppingListLoading extends ShoppingListState {}

class ShoppingListError extends ShoppingListState {
  final String message;
  ShoppingListError(this.message);
}

class ShoppingListEmpty extends ShoppingListState {}

class ShoppingListLoaded extends ShoppingListState {
  final List<ShoppingItem> items;
  ShoppingListLoaded(this.items);
}