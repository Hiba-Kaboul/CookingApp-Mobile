// presentation/bloc/bloc_mark_unpurchased/mark_unpurchased_event.dart
abstract class MarkUnpurchasedEvent {}

class MarkItemsAsUnpurchased extends MarkUnpurchasedEvent {
  final List<int> ids;
  MarkItemsAsUnpurchased(this.ids);
}