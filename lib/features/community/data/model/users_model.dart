class UsersPostsModel {
  final int status;
  final String message;
  final List<PostModel> data;
  final MetaModel meta; // أضفنا الـ meta هنا

  UsersPostsModel({
    required this.status,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory UsersPostsModel.fromJson(Map<String, dynamic> json) {
    return UsersPostsModel(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List).map((e) => PostModel.fromJson(e)).toList(),
      meta: MetaModel.fromJson(json['meta']), // قمنا بتهيئته
    );
  }
}

class PostModel {
  final int id;
  final String title;
  final String? description;
  final List<MediaModel> media;
  bool isLiked;
  int likesCount;
  bool isSaved;
  int savesCount;
   int commentsCount;
   int viewscount;
  final num avgRating;
  final UserInfo user;

  PostModel({
    required this.id,
    required this.title,
    required this.description,
    required this.media,
    required this.isLiked,
    required this.likesCount,
    required this.isSaved,
    required this.savesCount,
    required this.commentsCount,
    required this.viewscount,
    required this.avgRating,
    required this.user,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      media:
          (json['media'] as List).map((e) => MediaModel.fromJson(e)).toList(),
      isLiked: json['is_liked'] ?? false,
      likesCount: json['likes_count'],
      isSaved: json['is_saved'] ?? false,
      savesCount: json['saves_count'] ?? 0,
      commentsCount: json['comments_count'],
      viewscount: json['views_count'],
      avgRating: json['avg_rating'],
      user: UserInfo.fromJson(json['user']),
    );
  }
}

class MediaModel {
  final int id;
  final String url;
  final String type;
  final String? thumbnail;

  MediaModel({
    required this.id,
    required this.url,
    required this.type,
    this.thumbnail,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json['id'],
      url: json['url'],
      type: json['type'],
      thumbnail: json['thumbnail'],
    );
  }
}

class UserInfo {
  final int id;
  final String name;
  final String? avatar;

  UserInfo({
    required this.id,
    required this.name,
    this.avatar,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
    );
  }
}

class MetaModel {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final int from;
  final int to;

  MetaModel({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.from,
    required this.to,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
      total: json['total'],
      from: json['from'],
      to: json['to'],
    );
  }
}
