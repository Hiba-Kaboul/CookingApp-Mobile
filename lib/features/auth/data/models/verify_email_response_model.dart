class VerifyEmailResponseModel {
  final int status;
  final String message;
  final VerifyEmailData data;

  VerifyEmailResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory VerifyEmailResponseModel.fromJson(Map<String, dynamic> json) =>
      VerifyEmailResponseModel(
        status: json['status'],
        message: json['message'],
        data: VerifyEmailData.fromJson(json['data']),
      );
}

class VerifyEmailData {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final VerifyEmailUser user;

  VerifyEmailData({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  factory VerifyEmailData.fromJson(Map<String, dynamic> json) =>
      VerifyEmailData(
        accessToken: json['access_token'],
        tokenType: json['token_type'],
        expiresIn: json['expires_in'],
        user: VerifyEmailUser.fromJson(json['user']),
      );
}

class VerifyEmailUser {
  final int id;
  final String name;
  final String email;
  final String role;
  final bool verified;
  final String createdAt;

  VerifyEmailUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.verified,
    required this.createdAt,
  });

  factory VerifyEmailUser.fromJson(Map<String, dynamic> json) =>
      VerifyEmailUser(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        role: json['role'],
        verified: json['verified'],
        createdAt: json['created_at'],
      );
}