abstract class MarkNotificationReadState {}

class MarkNotificationReadInitial extends MarkNotificationReadState {}

class MarkNotificationReadLoading extends MarkNotificationReadState {
  final String notificationId;
  MarkNotificationReadLoading(this.notificationId);
}

class MarkNotificationReadSuccess extends MarkNotificationReadState {
  final String notificationId;
  MarkNotificationReadSuccess(this.notificationId);
}

class MarkNotificationReadError extends MarkNotificationReadState {
  final String notificationId;
  final String message;
  MarkNotificationReadError({
    required this.notificationId,
    required this.message,
  });
}
