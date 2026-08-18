import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api/trending_api.dart';
import 'trending_event.dart';
import 'trending_state.dart';

class TrendingBloc extends Bloc<TrendingEvent, TrendingState> {
  final TrendingApi api;

  TrendingBloc(this.api) : super(TrendingInitial()) {
    on<GetTrendingEvent>(_onGetTrending);
  }

  Future<void> _onGetTrending(
    GetTrendingEvent event,
    Emitter<TrendingState> emit,
  ) async {
    emit(TrendingLoading());

    try {
      final response = await api.getTrending();

      if (response.data.isEmpty) {
        emit(TrendingEmpty());
      } else {
        emit(TrendingSuccess(response.data));
      }
    } catch (e) {
      emit(TrendingError("صار في خطأ، حاول كمان مرة"));
    }
  }
}
