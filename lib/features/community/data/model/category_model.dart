class CategoryModel {
  final int id;
  final String name;
  final String image;
  final int recipesCount;
  final String createdAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.recipesCount,
    required this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      recipesCount: json["recipes_count"],
      createdAt: json["created_at"],
    );
  }
}