class PostsSearchResponse {
  final List<Post> data;
  final Meta meta;

  PostsSearchResponse({required this.data, required this.meta});

  factory PostsSearchResponse.fromMap(Map<String, dynamic> map) {
    return PostsSearchResponse(
      data: List<Post>.from(
        (map['data'] as List).map((e) => Post.fromMap(e)),
      ),
      meta: Meta.fromMap(map['meta']),
    );
  }
}

class Post {
  final int id;
  final String title;
  final String description;
  final int durationMinutes;
  final int servings;
  final PostStatus status;
  final PostCategory category;
  final List<PostMedia> media;
  final int viewsCount;
  final int likesCount;
  final int commentsCount;
  final num avgRating;
  final bool isLiked;
  final bool isSaved;
  final PostUser user;
  final String createdAt;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.servings,
    required this.status,
    required this.category,
    required this.media,
    required this.viewsCount,
    required this.likesCount,
    required this.commentsCount,
    required this.avgRating,
    required this.isLiked,
    required this.isSaved,
    required this.user,
    required this.createdAt,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      durationMinutes: map['duration_minutes'] ?? 0,
      servings: map['servings'] ?? 0,
      status: PostStatus.fromMap(map['status']),
      category: PostCategory.fromMap(map['category']),
      media: List<PostMedia>.from(
        (map['media'] as List? ?? []).map((e) => PostMedia.fromMap(e)),
      ),
      viewsCount: map['views_count'] ?? 0,
      likesCount: map['likes_count'] ?? 0,
      commentsCount: map['comments_count'] ?? 0,
      avgRating: map['avg_rating'] ?? 0,
      isLiked: map['is_liked'] ?? false,
      isSaved: map['is_saved'] ?? false,
      user: PostUser.fromMap(map['user']),
      createdAt: map['created_at'] ?? '',
    );
  }
}

class PostStatus {
  final String value;
  final String label;

  PostStatus({required this.value, required this.label});

  factory PostStatus.fromMap(Map<String, dynamic> map) {
    return PostStatus(
      value: map['value'] ?? '',
      label: map['label'] ?? '',
    );
  }
}

class PostCategory {
  final int id;
  final String name;

  PostCategory({required this.id, required this.name});

  factory PostCategory.fromMap(Map<String, dynamic> map) {
    return PostCategory(
      id: map['id'],
      name: map['name'] ?? '',
    );
  }
}

class PostMedia {
  final int id;
  final String type;
  final String url;
  final String? thumbnail;
  final int? duration;
  final int order;

  PostMedia({
    required this.id,
    required this.type,
    required this.url,
    this.thumbnail,
    this.duration,
    required this.order,
  });

  factory PostMedia.fromMap(Map<String, dynamic> map) {
    return PostMedia(
      id: map['id'],
      type: map['type'] ?? '',
      url: map['url'] ?? '',
      thumbnail: map['thumbnail'],
      duration: map['duration'],
      order: map['order'] ?? 0,
    );
  }
}

class PostUser {
  final int id;
  final String name;
  final String? avatar;

  PostUser({required this.id, required this.name, this.avatar});

  factory PostUser.fromMap(Map<String, dynamic> map) {
    return PostUser(
      id: map['id'],
      name: map['name'] ?? '',
      avatar: map['avatar'],
    );
  }
}

class Meta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final int from;
  final int to;

  Meta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.from,
    required this.to,
  });

  factory Meta.fromMap(Map<String, dynamic> map) {
    return Meta(
      currentPage: map['current_page'] ?? 1,
      lastPage: map['last_page'] ?? 1,
      perPage: map['per_page'] ?? 10,
      total: map['total'] ?? 0,
      from: map['from'] ?? 0,
      to: map['to'] ?? 0,
    );
  }
}