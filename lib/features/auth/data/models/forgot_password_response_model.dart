class ForgotPasswordResponseModel {
  final int status;
  final String message;

  ForgotPasswordResponseModel({
    required this.status,
    required this.message,
  });

  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordResponseModel(
        status: json['status'],
        message: json['message'],
      );
}