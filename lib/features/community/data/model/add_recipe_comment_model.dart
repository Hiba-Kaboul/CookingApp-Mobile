class AddRecipeComment {
  final int id;
  final String body;
  final CommentUser user;
  final String createdAt;

  AddRecipeComment({
    required this.id,
    required this.body,
    required this.user,
    required this.createdAt,
  });

  factory AddRecipeComment.fromMap(Map<String, dynamic> map) {
    final data = map['data'];
    return AddRecipeComment(
      id: data['id'],
      body: data['body'] ?? '',
      user: CommentUser.fromMap(data['user']),
      createdAt: data['created_at'] ?? '',
    );
  }
}

class CommentUser {
  final int id;
  final String name;
  final String? avatar;

  CommentUser({required this.id, required this.name, this.avatar});

  factory CommentUser.fromMap(Map<String, dynamic> map) {
    return CommentUser(
      id: map['id'],
      name: map['name'] ?? '',
      avatar: map['avatar'],
    );
  }
}