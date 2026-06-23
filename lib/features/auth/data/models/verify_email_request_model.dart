class VerifyEmailRequestModel {
  final String email;
  final String code;

  VerifyEmailRequestModel({
    required this.email,
    required this.code,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'code': code,
      };
}