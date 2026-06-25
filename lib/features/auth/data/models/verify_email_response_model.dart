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
  final String? avatar;
  final String? bio;
  final int postsCount;
  final String? emailVerifiedAt;
  final String createdAt;

  VerifyEmailUser({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.bio,
    required this.postsCount,
    this.emailVerifiedAt,
    required this.createdAt,
  });

  factory VerifyEmailUser.fromJson(Map<String, dynamic> json) {
    return VerifyEmailUser(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      bio: json['bio'],
      postsCount: json['posts_count'] ?? 0,
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'] ?? '',
    );
  }
}