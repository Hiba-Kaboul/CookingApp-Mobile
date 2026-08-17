// presentation/bloc/bloc_mark_unpurchased/mark_unpurchased_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api/mark_unpurchased_api.dart';
import 'mark_unpurchased_event.dart';
import 'mark_unpurchased_state.dart';

class MarkUnpurchasedBloc
    extends Bloc<MarkUnpurchasedEvent, MarkUnpurchasedState> {
  final MarkUnpurchasedApi api;

  MarkUnpurchasedBloc(this.api) : super(MarkUnpurchasedInitial()) {
    on<MarkItemsAsUnpurchased>(_onMark);
  }

  Future<void> _onMark(
    MarkItemsAsUnpurchased event,
    Emitter<MarkUnpurchasedState> emit,
  ) async {
    if (event.ids.isEmpty) {
      emit(MarkUnpurchasedFailure("لم يتم تحديد أي عنصر"));
      return;
    }

    emit(MarkUnpurchasedLoading());

    try {
      final response = await api.markUnpurchased(event.ids);
      emit(MarkUnpurchasedSuccess(response.updatedCount));
    } catch (e) {
      emit(MarkUnpurchasedFailure("تعذر تحديث العناصر"));
    }
  }
}