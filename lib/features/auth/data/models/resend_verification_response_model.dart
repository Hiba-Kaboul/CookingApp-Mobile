class ResendVerificationResponseModel {
  final int status;
  final String message;

  ResendVerificationResponseModel({
    required this.status,
    required this.message,
  });

  factory ResendVerificationResponseModel.fromJson(
          Map<String, dynamic> json) =>
      ResendVerificationResponseModel(
        status: json['status'],
        message: json['message'],
      );
}