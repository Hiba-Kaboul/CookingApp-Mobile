abstract class FcmTokenEvent {}

class UpdateFcmTokenEvent extends FcmTokenEvent {
  final String fcmToken;
  UpdateFcmTokenEvent(this.fcmToken);
}
