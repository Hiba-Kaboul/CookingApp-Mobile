class LikeRecipe {
  final bool liked;
  final int likesCount;

  LikeRecipe({required this.liked, required this.likesCount});

  factory LikeRecipe.fromMap(Map<String, dynamic> map) {
    final data = map['data'];
    return LikeRecipe(
      liked: data['liked'] ?? false,
      likesCount: data['likes_count'] ?? 0,
    );
  }
}