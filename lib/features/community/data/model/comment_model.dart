// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CommentModel {
  final int status;
  final String message;
  final CommentsData data;

  CommentModel({
    required this.status,
    required this.message,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'data': data.toMap(),
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      status: map['status'] as int,
      message: map['message'] as String,
      data: CommentsData.fromMap(map['data'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class CommentsData {
  final int id;
  final String body;
  final UserComment user;

  CommentsData({
    required this.id,
    required this.body,
    required this.user,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'body': body,
      'user': user.toMap(),
    };
  }

  factory CommentsData.fromMap(Map<String, dynamic> map) {
    return CommentsData(
      id: map['id'] as int,
      body: map['body'] as String,
      user: UserComment.fromMap(map['user'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentsData.fromJson(String source) =>
      CommentsData.fromMap(json.decode(source) as Map<String, dynamic>);
}

class UserComment {
  final int id;
  final String name;
  final String avatar;

  UserComment({
    required this.id,
    required this.name,
    required this.avatar,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'avatar': avatar,
    };
  }

  factory UserComment.fromMap(Map<String, dynamic> map) {
    return UserComment(
      id: map['id'] as int,
      name: map['name'] as String,
      avatar: map['avatar'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserComment.fromJson(String source) =>
      UserComment.fromMap(json.decode(source) as Map<String, dynamic>);
}