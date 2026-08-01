
import '../../data/models/saved_item_model.dart';

abstract class SavedItemsState {}

class SavedItemsInitial extends SavedItemsState {}

class SavedItemsLoading extends SavedItemsState {}

class SavedItemsError extends SavedItemsState {
  final String message;
  SavedItemsError(this.message);
}

class SavedItemsSuccess extends SavedItemsState {
  final List<SavedItem> items;
  SavedItemsSuccess(this.items);
}