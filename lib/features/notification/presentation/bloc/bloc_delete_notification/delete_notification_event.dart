abstract class DeleteNotificationEvent {}

class DeleteNotificationRequested extends DeleteNotificationEvent {
  final String notificationId;
  DeleteNotificationRequested(this.notificationId);
}
