class RegisterResponseModel {
  final int status;
  final String message;
  final RegisterUserData data;

  RegisterResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      RegisterResponseModel(
        status: json['status'],
        message: json['message'],
        data: RegisterUserData.fromJson(json['data']),
      );
}

class RegisterUserData {
  final int id;
  final String name;
  final String email;
  final String? avatar;
  final String? bio;
  final int postsCount;
  final String? emailVerifiedAt;
  final String createdAt;

  RegisterUserData({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.bio,
    required this.postsCount,
    this.emailVerifiedAt,
    required this.createdAt,
  });

  factory RegisterUserData.fromJson(Map<String, dynamic> json) {
    return RegisterUserData(
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