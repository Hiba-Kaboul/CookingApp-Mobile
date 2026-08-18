import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api/mark_notification_read_api.dart';
import 'mark_notification_read_event.dart';
import 'mark_notification_read_state.dart';

class MarkNotificationReadBloc
    extends Bloc<MarkNotificationReadEvent, MarkNotificationReadState> {
  final MarkNotificationReadApi api;

  MarkNotificationReadBloc(this.api) : super(MarkNotificationReadInitial()) {
    on<MarkNotificationReadEventRequested>(_onMarkRead);
  }

  Future<void> _onMarkRead(
    MarkNotificationReadEventRequested event,
    Emitter<MarkNotificationReadState> emit,
  ) async {
    emit(MarkNotificationReadLoading(event.notificationId));

    try {
      await api.markNotificationRead(event.notificationId);
      emit(MarkNotificationReadSuccess(event.notificationId));
    } catch (e) {
      emit(MarkNotificationReadError(
        notificationId: event.notificationId,
        message: "تعذر تحديد الإشعار كمقروء",
      ));
    }
  }
}
