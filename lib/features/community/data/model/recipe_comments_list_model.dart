class RecipeCommentsResponse {
  final List<RecipeCommentItem> data;
  final RecipeCommentsMeta meta;

  RecipeCommentsResponse({required this.data, required this.meta});

  factory RecipeCommentsResponse.fromMap(Map<String, dynamic> map) {
    return RecipeCommentsResponse(
      data: List<RecipeCommentItem>.from(
        (map['data'] as List).map((e) => RecipeCommentItem.fromMap(e)),
      ),
      meta: RecipeCommentsMeta.fromMap(map['meta']),
    );
  }
}

class RecipeCommentItem {
  final int id;
  final String body;
  final RecipeCommentUser user;
  final String createdAt;

  RecipeCommentItem({
    required this.id,
    required this.body,
    required this.user,
    required this.createdAt,
  });

  factory RecipeCommentItem.fromMap(Map<String, dynamic> map) {
    return RecipeCommentItem(
      id: map['id'],
      body: map['body'] ?? '',
      user: RecipeCommentUser.fromMap(map['user']),
      createdAt: map['created_at'] ?? '',
    );
  }
}

class RecipeCommentUser {
  final int id;
  final String name;
  final String? avatar;

  RecipeCommentUser({required this.id, required this.name, this.avatar});

  factory RecipeCommentUser.fromMap(Map<String, dynamic> map) {
    return RecipeCommentUser(
      id: map['id'],
      name: map['name'] ?? '',
      avatar: map['avatar'],
    );
  }
}

class RecipeCommentsMeta {
  final int currentPage;
  final int lastPage;
  final int total;

  RecipeCommentsMeta({
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory RecipeCommentsMeta.fromMap(Map<String, dynamic> map) {
    return RecipeCommentsMeta(
      currentPage: map['current_page'] ?? 1,
      lastPage: map['last_page'] ?? 1,
      total: map['total'] ?? 0,
    );
  }
}