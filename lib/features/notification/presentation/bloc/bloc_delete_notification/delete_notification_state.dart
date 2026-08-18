abstract class DeleteNotificationState {}

class DeleteNotificationInitial extends DeleteNotificationState {}

class DeleteNotificationLoading extends DeleteNotificationState {
  final String notificationId;
  DeleteNotificationLoading(this.notificationId);
}

class DeleteNotificationSuccess extends DeleteNotificationState {
  final String notificationId;
  DeleteNotificationSuccess(this.notificationId);
}

class DeleteNotificationError extends DeleteNotificationState {
  final String notificationId;
  final String message;
  DeleteNotificationError({
    required this.notificationId,
    required this.message,
  });
}
