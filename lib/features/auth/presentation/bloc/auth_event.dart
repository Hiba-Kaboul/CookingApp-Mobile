// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class AuthEvent {}

// صفحة Register
class RegisterSubmitted extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  RegisterSubmitted({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });
}

// صفحة OTP — تأكيد الرمز
class VerifyOtpSubmitted extends AuthEvent {
  final String email;
  final String code;

  VerifyOtpSubmitted({required this.email, required this.code});
}

// صفحة OTP — إعادة إرسال الرمز
class ResendOtpRequested extends AuthEvent {
  final String email;
  ResendOtpRequested({required this.email});
}

// صفحة Login
class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  LoginSubmitted({required this.email, required this.password});
}

//logout
class LogoutRequested extends AuthEvent {
  final String token;
  LogoutRequested({
    required this.token,
  });
}

class ForgotPasswordSubmitted extends AuthEvent {
  final String email;
  ForgotPasswordSubmitted({required this.email});
}

class ResetPasswordSubmitted extends AuthEvent {
  final String email;
  final String code;
  final String password;
  final String passwordConfirmation;

  ResetPasswordSubmitted({
    required this.email,
    required this.code,
    required this.password,
    required this.passwordConfirmation,
  });
}
