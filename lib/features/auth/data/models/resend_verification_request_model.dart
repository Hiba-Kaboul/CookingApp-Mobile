class ResendVerificationRequestModel {
  final String email;

  ResendVerificationRequestModel({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}