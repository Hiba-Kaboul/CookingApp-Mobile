// presentation/bloc/bloc_delete_shopping_items/delete_shopping_items_event.dart
abstract class DeleteShoppingItemsEvent {}

class DeleteSelectedShoppingItems extends DeleteShoppingItemsEvent {
  final List<int> ids;
  DeleteSelectedShoppingItems(this.ids);
}