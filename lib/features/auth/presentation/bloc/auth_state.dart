abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class RegisterSuccess extends AuthState {
  final String email;
  RegisterSuccess(this.email);
}

class VerifyOtpSuccess extends AuthState {}

class ResendOtpSuccess extends AuthState {}

class LoginSuccess extends AuthState {
  final String token;
  final String name;
  LoginSuccess({required this.token, required this.name});
}

class LogoutSuccess extends AuthState {}

class ForgetPasswordSuccess extends AuthState {
  final String email;
  ForgetPasswordSuccess(this.email);
}

class ResetPasswordSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}
