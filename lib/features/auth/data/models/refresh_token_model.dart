class RefreshTokenResponseModel {
  final int status;
  final String message;
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final RefreshTokenUser user;

  RefreshTokenResponseModel({
    required this.status,
    required this.message,
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return RefreshTokenResponseModel(
      status: json['status'],
      message: json['message'],
      accessToken: data['access_token'],
      tokenType: data['token_type'],
      expiresIn: data['expires_in'],
      user: RefreshTokenUser.fromJson(data['user']),
    );
  }
}

class RefreshTokenUser {
  final int id;
  final String name;
  final String email;
  final String? avatar;
  final String? bio;
  final int postsCount;
  final String? emailVerifiedAt;
  final String? createdAt;

  RefreshTokenUser({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.bio,
    required this.postsCount,
    this.emailVerifiedAt,
    this.createdAt,
  });

  factory RefreshTokenUser.fromJson(Map<String, dynamic> json) =>
      RefreshTokenUser(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        avatar: json['avatar'],
        bio: json['bio'],
        postsCount: json['posts_count'] ?? 0,
        emailVerifiedAt: json['email_verified_at'],
        createdAt: json['created_at'],
      );
}