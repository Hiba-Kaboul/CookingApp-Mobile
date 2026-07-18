class CategoriesModel {
  final int status;
  final String message;
  final List<CategoryModel> data;

  CategoriesModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList(),
    );
  }
}

class CategoryModel {
  final int id;
  final String name;
  final String? icon;
  final int postsCount;

  CategoryModel({
    required this.id,
    required this.name,
    this.icon,
    required this.postsCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      postsCount: json['posts_count'],
    );
  }
}