abstract class FcmTokenState {}

class FcmTokenInitial extends FcmTokenState {}

class FcmTokenLoading extends FcmTokenState {}

class FcmTokenSuccess extends FcmTokenState {}

class FcmTokenError extends FcmTokenState {
  final String message;
  FcmTokenError(this.message);
}
