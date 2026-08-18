abstract class MarkAllNotificationsReadState {}

class MarkAllNotificationsReadInitial extends MarkAllNotificationsReadState {}

class MarkAllNotificationsReadLoading extends MarkAllNotificationsReadState {}

class MarkAllNotificationsReadSuccess extends MarkAllNotificationsReadState {}

class MarkAllNotificationsReadError extends MarkAllNotificationsReadState {
  final String message;
  MarkAllNotificationsReadError(this.message);
}
