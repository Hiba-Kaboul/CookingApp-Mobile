class ChangePassword {
  final String message;

  ChangePassword({required this.message});

  factory ChangePassword.fromMap(Map<String, dynamic> map) {
    return ChangePassword(
      message: map['message'] ?? 'تم تغيير كلمة المرور بنجاح',
    );
  }
}