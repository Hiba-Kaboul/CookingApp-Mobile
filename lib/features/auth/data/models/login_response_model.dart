class LoginResponseModel {
  final int status;
  final String message;
  final LoginData data;

  LoginResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        status: json['status'],
        message: json['message'],
        data: LoginData.fromJson(json['data']),
      );
}

class LoginData {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final LoginUser user;

  LoginData({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        accessToken: json['access_token'],
        tokenType: json['token_type'],
        expiresIn: json['expires_in'],
        user: LoginUser.fromJson(json['user']),
      );
}

class LoginUser {
  final int id;
  final String name;
  final String email;
  final String? avatar;
  final String? bio;
  final int postsCount;
  final String? emailVerifiedAt;
  final String createdAt;

  LoginUser({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.bio,
    required this.postsCount,
    this.emailVerifiedAt,
    required this.createdAt,
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
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