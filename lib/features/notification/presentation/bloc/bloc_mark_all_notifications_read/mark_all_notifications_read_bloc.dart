import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api/mark_all_notifications_read_api.dart';
import 'mark_all_notifications_read_event.dart';
import 'mark_all_notifications_read_state.dart';

class MarkAllNotificationsReadBloc extends Bloc<MarkAllNotificationsReadEvent,
    MarkAllNotificationsReadState> {
  final MarkAllNotificationsReadApi api;

  MarkAllNotificationsReadBloc(this.api)
      : super(MarkAllNotificationsReadInitial()) {
    on<MarkAllNotificationsReadRequested>(_onMarkAllRead);
  }

  Future<void> _onMarkAllRead(
    MarkAllNotificationsReadRequested event,
    Emitter<MarkAllNotificationsReadState> emit,
  ) async {
    emit(MarkAllNotificationsReadLoading());

    try {
      await api.markAllNotificationsRead();
      emit(MarkAllNotificationsReadSuccess());
    } catch (e) {
      emit(MarkAllNotificationsReadError("تعذر تحديد كل الإشعارات كمقروءة"));
    }
  }
}
