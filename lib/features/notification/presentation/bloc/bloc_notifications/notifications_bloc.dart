import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api/notifications_api.dart';
import '../../../data/models/notification_model.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsApi api;

  List<NotificationModel> _items = [];

  NotificationsBloc(this.api) : super(NotificationsInitial()) {
    on<GetNotificationsEvent>(_onGetNotifications);
    on<RemoveNotificationLocallyEvent>(_onRemoveLocally);
    on<ClearUnreadLocallyEvent>(_onClearUnreadLocally);
  }

  Future<void> _onGetNotifications(
    GetNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoading());

    try {
      final response = await api.getNotifications();
      _items = response.data;

      if (_items.isEmpty) {
        emit(NotificationsEmpty());
      } else {
        emit(NotificationsSuccess(List.from(_items)));
      }
    } catch (e) {
      emit(NotificationsError("صار في خطأ، حاول كمان مرة"));
    }
  }

  void _onRemoveLocally(
    RemoveNotificationLocallyEvent event,
    Emitter<NotificationsState> emit,
  ) {
    _items.removeWhere((item) => item.id == event.notificationId);

    if (_items.isEmpty) {
      emit(NotificationsEmpty());
    } else {
      emit(NotificationsSuccess(List.from(_items)));
    }
  }

  void _onClearUnreadLocally(
    ClearUnreadLocallyEvent event,
    Emitter<NotificationsState> emit,
  ) {
    _items = _items.map((item) => item.copyWith(isRead: true)).toList();

    if (_items.isEmpty) {
      emit(NotificationsEmpty());
    } else {
      emit(NotificationsSuccess(List.from(_items)));
    }
  }
}
