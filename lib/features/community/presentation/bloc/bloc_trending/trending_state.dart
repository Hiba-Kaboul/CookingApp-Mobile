import '../../../data/model/trending_model.dart';

abstract class TrendingState {}

class TrendingInitial extends TrendingState {}

class TrendingLoading extends TrendingState {}

class TrendingError extends TrendingState {
  final String message;
  TrendingError(this.message);
}

class TrendingEmpty extends TrendingState {}

class TrendingSuccess extends TrendingState {
  final List<TrendingItem> items;
  TrendingSuccess(this.items);
}
