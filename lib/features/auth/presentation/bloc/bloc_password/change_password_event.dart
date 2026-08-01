abstract class ChangePasswordEvent {}

class ChangePasswordSubmitted extends ChangePasswordEvent {
  final String password;
  final String newPassword;
  final String newPasswordConfirmation;

  ChangePasswordSubmitted({
    required this.password,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });
}