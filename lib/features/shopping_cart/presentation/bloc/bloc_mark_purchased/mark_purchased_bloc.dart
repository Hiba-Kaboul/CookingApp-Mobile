// presentation/bloc/bloc_mark_purchased/mark_purchased_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api/mark_purchased_api.dart';
import '../../../../notification/data/fcm_service.dart';
import 'mark_purchased_event.dart';
import 'mark_purchased_state.dart';

class MarkPurchasedBloc extends Bloc<MarkPurchasedEvent, MarkPurchasedState> {
  final MarkPurchasedApi api;

  MarkPurchasedBloc(this.api) : super(MarkPurchasedInitial()) {
    on<MarkItemsAsPurchased>(_onMark);
  }

  Future<void> _onMark(
    MarkItemsAsPurchased event,
    Emitter<MarkPurchasedState> emit,
  ) async {
    if (event.ids.isEmpty) {
      emit(MarkPurchasedFailure("لم يتم تحديد أي عنصر"));
      return;
    }

    emit(MarkPurchasedLoading());

    try {
      final response = await api.markPurchased(event.ids);
      await FcmService.cancelShoppingReminders(event.ids);
      emit(MarkPurchasedSuccess(response.updatedCount));
    } catch (e) {
      emit(MarkPurchasedFailure("تعذر تحديث العناصر"));
    }
  }
}