// ignore_for_file: public_member_api_docs, sort_constructors_first

class CommentUserModel {
  final int id;
  final String name;
  final String? avatar;

  CommentUserModel({
    required this.id,
    required this.name,
    required this.avatar,
  });

  factory CommentUserModel.fromJson(Map<String, dynamic> json) {
    return CommentUserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
    );
  }
}

class CommentItemModel {
  final int id;
  final String body;
  final CommentUserModel user;
  final String createdAt;

  CommentItemModel({
    required this.id,
    required this.body,
    required this.user,
    required this.createdAt,
  });

  factory CommentItemModel.fromJson(Map<String, dynamic> json) {
    return CommentItemModel(
      id: json['id'] as int,
      body: json['body'] as String,
      user: CommentUserModel.fromJson(json['user'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String,
    );
  }
}

class CommentsMetaModel {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  CommentsMetaModel({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory CommentsMetaModel.fromJson(Map<String, dynamic> json) {
    return CommentsMetaModel(
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
      perPage: json['per_page'] as int,
      total: json['total'] as int,
    );
  }

  bool get hasMore => currentPage < lastPage;
}

class CommentsListModel {
  final int status;
  final String message;
  final List<CommentItemModel> data;
  final CommentsMetaModel meta;

  CommentsListModel({
    required this.status,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory CommentsListModel.fromJson(Map<String, dynamic> json) {
    return CommentsListModel(
      status: json['status'] as int,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((e) => CommentItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: CommentsMetaModel.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }
}