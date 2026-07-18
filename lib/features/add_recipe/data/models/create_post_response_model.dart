class CreatePostResponseModel {
  final int status;
  final String message;
  final PostData data;

  CreatePostResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CreatePostResponseModel.fromJson(Map<String, dynamic> json) {
    return CreatePostResponseModel(
      status: json['status'],
      message: json['message'] ?? '',
      data: PostData.fromJson(json['data']),
    );
  }
}

class PostData {
  final int id;
  final String title;
  final String description;
  final int durationMinutes;
  final int servings;

  final PostStatus status;
  final String? rejectionReason;

  final Category category;
  final PostUser user;

  final List<Media> media;
  final List<StepModel> steps;
  final List<IngredientModel> ingredients;

  final bool isLiked;
  final bool isSaved;

  final String createdAt;

  PostData({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.servings,
    required this.status,
    this.rejectionReason,
    required this.category,
    required this.user,
    required this.media,
    required this.steps,
    required this.ingredients,
    required this.isLiked,
    required this.isSaved,
    required this.createdAt,
  });

  factory PostData.fromJson(Map<String, dynamic> json) {
    return PostData(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      durationMinutes: json['duration_minutes'] ?? 0,
      servings: json['servings'] ?? 0,
      status: PostStatus.fromJson(json['status']),
      rejectionReason: json['rejection_reason'],
      category: Category.fromJson(json['category']),
      user: PostUser.fromJson(json['user']),
      media: (json['media'] as List)
          .map((e) => Media.fromJson(e))
          .toList(),
      steps: (json['steps'] as List)
          .map((e) => StepModel.fromJson(e))
          .toList(),
      ingredients: (json['ingredients'] as List)
          .map((e) => IngredientModel.fromJson(e))
          .toList(),
      isLiked: json['is_liked'] ?? false,
      isSaved: json['is_saved'] ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }
}

class PostStatus {
  final String value;
  final String label;

  PostStatus({
    required this.value,
    required this.label,
  });

  factory PostStatus.fromJson(Map<String, dynamic> json) {
    return PostStatus(
      value: json['value'] ?? '',
      label: json['label'] ?? '',
    );
  }
}

class Category {
  final int id;
  final String name;
  final String? icon;

  Category({
    required this.id,
    required this.name,
    this.icon,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'] ?? '',
      icon: json['icon'],
    );
  }
}

class PostUser {
  final int id;
  final String name;
  final String? avatar;

  PostUser({
    required this.id,
    required this.name,
    this.avatar,
  });

  factory PostUser.fromJson(Map<String, dynamic> json) {
    return PostUser(
      id: json['id'],
      name: json['name'] ?? '',
      avatar: json['avatar'],
    );
  }
}

class Media {
  final int id;
  final String type;
  final String url;
  final int order;

  Media({
    required this.id,
    required this.type,
    required this.url,
    required this.order,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'],
      type: json['type'] ?? '',
      url: json['url'] ?? '',
      order: json['order'] ?? 0,
    );
  }
}

class StepModel {
  final int order;
  final String description;

  StepModel({
    required this.order,
    required this.description,
  });

  factory StepModel.fromJson(Map<String, dynamic> json) {
    return StepModel(
      order: json['order'] ?? 0,
      description: json['description'] ?? '',
    );
  }
}

class IngredientModel {
  final String name;
  final String quantity;

  IngredientModel({
    required this.name,
    required this.quantity,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? '',
    );
  }
}