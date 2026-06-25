class ProfileResponseModel {
  final int status;
  final String message;
  final ProfileData data;

  ProfileResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      status: json['status'],
      message: json['message'],
      data: ProfileData.fromJson(json['data']),
    );
  }
}

class ProfileData {
  final int id;
  final String name;
  final String email;
  final String? avatar;
  final String? bio;
  final int posts_count;
  final ProfileOption language;
  final ProfileOption theme;
  final ProfileOption userStatus;
  final String? emailVerifiedAt;
  final String createdAt;

  ProfileData({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.bio,
    required this.posts_count,
    required this.language,
    required this.theme,
    required this.userStatus,
    this.emailVerifiedAt,
    required this.createdAt,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      bio: json['bio'],
      posts_count: json['posts_count'] ?? 0,
      language: ProfileOption.fromJson(json['language']),
      theme: ProfileOption.fromJson(json['theme']),
      userStatus: ProfileOption.fromJson(json['status']),
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'] ?? '',
    );
  }
}

class ProfileOption {
  final String value;
  final String label;

  ProfileOption({
    required this.value,
    required this.label,
  });

  factory ProfileOption.fromJson(Map<String, dynamic> json) {
    return ProfileOption(
      value: json['value'] ?? '',
      label: json['label'] ?? '',
    );
  }
}