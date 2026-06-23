class ResetPasswordResponseModel {
  final int status;
  final String message;

  ResetPasswordResponseModel({
    required this.status,
    required this.message,
  });

  factory ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      ResetPasswordResponseModel(
        status: json['status'],
        message: json['message'],
      );
}