// presentation/bloc/bloc_mark_purchased/mark_purchased_state.dart
abstract class MarkPurchasedState {}

class MarkPurchasedInitial extends MarkPurchasedState {}

class MarkPurchasedLoading extends MarkPurchasedState {}

class MarkPurchasedSuccess extends MarkPurchasedState {
  final int updatedCount;
  MarkPurchasedSuccess(this.updatedCount);
}

class MarkPurchasedFailure extends MarkPurchasedState {
  final String message;
  MarkPurchasedFailure(this.message);
}