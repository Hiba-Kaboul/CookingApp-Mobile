// presentation/bloc/bloc_mark_unpurchased/mark_unpurchased_state.dart
abstract class MarkUnpurchasedState {}

class MarkUnpurchasedInitial extends MarkUnpurchasedState {}

class MarkUnpurchasedLoading extends MarkUnpurchasedState {}

class MarkUnpurchasedSuccess extends MarkUnpurchasedState {
  final int updatedCount;
  MarkUnpurchasedSuccess(this.updatedCount);
}

class MarkUnpurchasedFailure extends MarkUnpurchasedState {
  final String message;
  MarkUnpurchasedFailure(this.message);
}