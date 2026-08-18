// presentation/bloc/bloc_delete_shopping_items/delete_shopping_items_state.dart
abstract class DeleteShoppingItemsState {}

class DeleteShoppingItemsInitial extends DeleteShoppingItemsState {}

class DeleteShoppingItemsLoading extends DeleteShoppingItemsState {}

class DeleteShoppingItemsSuccess extends DeleteShoppingItemsState {
  final List<int> deletedIds;
  DeleteShoppingItemsSuccess(this.deletedIds);
}

class DeleteShoppingItemsFailure extends DeleteShoppingItemsState {
  final String message;
  DeleteShoppingItemsFailure(this.message);
}