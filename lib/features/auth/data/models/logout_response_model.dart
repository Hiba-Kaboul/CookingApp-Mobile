class LogoutResponseModel {
  final int status;
  final String message;

  LogoutResponseModel({
    required this.status,
    required this.message,
  });

  factory LogoutResponseModel.fromJson(Map<String, dynamic> json) =>
      LogoutResponseModel(
        status: json['status'],
        message: json['message'],
      );
}