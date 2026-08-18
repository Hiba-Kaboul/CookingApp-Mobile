abstract class MarkNotificationReadEvent {}

class MarkNotificationReadEventRequested extends MarkNotificationReadEvent {
  final String notificationId;
  MarkNotificationReadEventRequested(this.notificationId);
}
