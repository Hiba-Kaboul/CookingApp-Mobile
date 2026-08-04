class AdminRecipeDetailModel {
  final int id;
  final String name;
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final List<AdminRecipeMedia> media;
  final int prepTime;
  final int cookTime;
  final int servings;
  final int calories;
  final int carbs;
  final int protein;
  final int fat;
  final String difficulty;
  final String userName;
  final String? userAvatar;
  final String categoryName;
  final String cuisineName;

  AdminRecipeDetailModel({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.media,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.difficulty,
    required this.userName,
    this.userAvatar,
    required this.categoryName,
    required this.cuisineName,
  });

  factory AdminRecipeDetailModel.fromJson(Map<String, dynamic> json) {
    return AdminRecipeDetailModel(
      id: json["id"],
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      ingredients: List<String>.from(json["ingredients"] ?? []),
      steps: List<String>.from(json["steps"] ?? []),
      media: (json["media"] as List? ?? [])
          .map((e) => AdminRecipeMedia.fromJson(e))
          .toList(),
      prepTime: json["prep_time"] ?? 0,
      cookTime: json["cook_time"] ?? 0,
      servings: json["servings"] ?? 0,
      calories: json["nutrition"]?["calories"] ?? 0,
      carbs: json["nutrition"]?["carbs"] ?? 0,
      protein: json["nutrition"]?["protein"] ?? 0,
      fat: json["nutrition"]?["fat"] ?? 0,
      difficulty: json["difficulty"]?["label"] ?? "",
      userName: json["user"]?["name"] ?? "",
      userAvatar: json["user"]?["avatar"],
      categoryName: json["category"]?["name"] ?? "",
      cuisineName: json["category"]?["cuisine"]?["name"] ?? "",
    );
  }
}

class AdminRecipeMedia {
  final String url;
  final String type;

  AdminRecipeMedia({
    required this.url,
    required this.type,
  });

  factory AdminRecipeMedia.fromJson(Map<String, dynamic> json) {
    final dynamic rawType = json["type"];
    String type = "image";
    if (rawType is Map) {
      type = rawType["value"]?.toString() ?? "image";
    } else if (rawType != null) {
      type = rawType.toString();
    }

    return AdminRecipeMedia(
      url: json["url"] ?? "",
      type: type,
    );
  }
}
