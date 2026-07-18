// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LikeUnlikePosts {
  final int status;
  final String message;
  final LikePosts data;
  LikeUnlikePosts({
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

  factory LikeUnlikePosts.fromMap(Map<String, dynamic> map) {
    return LikeUnlikePosts(
      status: map['status'] as int,
      message: map['message'] as String,
      data: LikePosts.fromMap(map['data'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory LikeUnlikePosts.fromJson(String source) => LikeUnlikePosts.fromMap(json.decode(source) as Map<String, dynamic>);
}

class LikePosts {
  final bool liked;
  final int likesCount;
  LikePosts({
    required this.liked,
    required this.likesCount
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'liked': liked,
      'likes_count': likesCount,
    };
  }

  factory LikePosts.fromMap(Map<String, dynamic> map) {
    return LikePosts(
      liked: map['liked'] as bool,
      likesCount: map['likes_count'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LikePosts.fromJson(String source) => LikePosts.fromMap(json.decode(source) as Map<String, dynamic>);
}
