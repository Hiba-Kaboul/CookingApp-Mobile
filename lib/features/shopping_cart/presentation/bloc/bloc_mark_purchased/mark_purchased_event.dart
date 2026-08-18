// presentation/bloc/bloc_mark_purchased/mark_purchased_event.dart
abstract class MarkPurchasedEvent {}

class MarkItemsAsPurchased extends MarkPurchasedEvent {
  final List<int> ids;
  MarkItemsAsPurchased(this.ids);
}