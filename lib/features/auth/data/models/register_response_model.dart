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
  final String role;
  final bool verified;
  final String createdAt;

  RegisterUserData({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.verified,
    required this.createdAt,
  });

  factory RegisterUserData.fromJson(Map<String, dynamic> json) =>
      RegisterUserData(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        role: json['role'],
        verified: json['verified'],
        createdAt: json['created_at'],
      );
}