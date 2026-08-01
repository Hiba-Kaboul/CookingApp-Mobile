class CuisineModel {
  final int id;
  final String name;
  final String image;
  final int categoriesCount;
  final String createdAt;

  CuisineModel({
    required this.id,
    required this.name,
    required this.image,
    required this.categoriesCount,
    required this.createdAt,
  });

  factory CuisineModel.fromJson(Map<String, dynamic> json) {
    return CuisineModel(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      categoriesCount: json["categories_count"],
      createdAt: json["created_at"],
    );
  }
}