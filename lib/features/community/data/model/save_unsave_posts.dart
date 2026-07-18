// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SaveUnsavePosts {
  final int status;
  final String message;
  final Savemodel data;
  SaveUnsavePosts({
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

  factory SaveUnsavePosts.fromMap(Map<String, dynamic> map) {
  return SaveUnsavePosts(
    status: map['status'],
    message: map['message'],
    data: Savemodel.fromMap(map['data']),
  );
}

  String toJson() => json.encode(toMap());

  factory SaveUnsavePosts.fromJson(String source) =>
      SaveUnsavePosts.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Savemodel {
  bool isSaved;
  int savesCount;

  Savemodel({
    required this.isSaved,
    required this.savesCount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'saved': isSaved,
      'saves_count': savesCount,
    };
  }

  factory Savemodel.fromMap(Map<String, dynamic> map) {
    return Savemodel(
      isSaved: map['saved'] ?? false,
      savesCount: map['saves_count'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Savemodel.fromJson(String source) =>
      Savemodel.fromMap(json.decode(source) as Map<String, dynamic>);
}