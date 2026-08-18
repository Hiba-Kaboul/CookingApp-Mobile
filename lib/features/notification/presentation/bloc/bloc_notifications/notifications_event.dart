abstract class NotificationsEvent {}

class GetNotificationsEvent extends NotificationsEvent {}

class RemoveNotificationLocallyEvent extends NotificationsEvent {
  final String notificationId;
  RemoveNotificationLocallyEvent(this.notificationId);
}

class ClearUnreadLocallyEvent extends NotificationsEvent {}
