import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api/delete_notification_api.dart';
import 'delete_notification_event.dart';
import 'delete_notification_state.dart';

class DeleteNotificationBloc
    extends Bloc<DeleteNotificationEvent, DeleteNotificationState> {
  final DeleteNotificationApi api;

  DeleteNotificationBloc(this.api) : super(DeleteNotificationInitial()) {
    on<DeleteNotificationRequested>(_onDelete);
  }

  Future<void> _onDelete(
    DeleteNotificationRequested event,
    Emitter<DeleteNotificationState> emit,
  ) async {
    emit(DeleteNotificationLoading(event.notificationId));

    try {
      await api.deleteNotification(event.notificationId);
      emit(DeleteNotificationSuccess(event.notificationId));
    } catch (e) {
      emit(DeleteNotificationError(
        notificationId: event.notificationId,
        message: "تعذر حذف الإشعار",
      ));
    }
  }
}
