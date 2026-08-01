class RecipeModel {
  final int id;
  final String name;
  final String description;

  final List<String> ingredients;
  final List<String> steps;
  final List<String> images;

  final int prepTime;
  final int cookTime;
  final int servings;

  final int calories;
  final int carbs;
  final int protein;
  final int fat;

  final String difficulty;

  final String chefName;

  final int likesCount;
  final int commentsCount;

  final bool isLiked;
  final bool isSaved;

  RecipeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.images,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.difficulty,
    required this.chefName,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
    required this.isSaved,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json["id"],
      name: json["name"],
      description: json["description"] ?? "",
      ingredients: List<String>.from(json["ingredients"] ?? []),
      steps: List<String>.from(json["steps"] ?? []),
      images:
          (json["media"] as List?)?.map((e) => e["url"] as String).toList() ??
              [],
      prepTime: json["prep_time"] ?? 0,
      cookTime: json["cook_time"] ?? 0,
      servings: json["servings"] ?? 0,
      calories: json["nutrition"]?["calories"] ?? 0,
      carbs: json["nutrition"]?["carbs"] ?? 0,
      protein: json["nutrition"]?["protein"] ?? 0,
      fat: json["nutrition"]?["fat"] ?? 0,
      difficulty: json["difficulty"]?["label"] ?? "",
      chefName: json["user"]?["name"] ?? "",
      likesCount: json["likes_count"] ?? 0,
      commentsCount: json["comments_count"] ?? 0,
      isLiked: json["is_liked"] ?? false,
      isSaved: json["is_saved"] ?? false,
    );
  }
}
