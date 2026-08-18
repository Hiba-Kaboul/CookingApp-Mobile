class RecipeDetailModel {
  final int id;
  final String title;
  final String description;
  final int durationMinutes;
  final int servings;
  final String userName;
  final String? userAvatar;
  final List<RecipeDetailMedia> media;
  final List<IngredientModel> ingredients;
  final List<StepModel> steps;

  RecipeDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.servings,
    required this.userName,
    this.userAvatar,
    required this.media,
    required this.ingredients,
    required this.steps,
  });

  factory RecipeDetailModel.fromJson(Map<String, dynamic> json) {
    return RecipeDetailModel(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      durationMinutes: json["duration_minutes"],
      servings: json["servings"],
      userName: json["user"]["name"],
      userAvatar: json["user"]?["avatar"],
      media: (json["media"] as List)
          .map((e) => RecipeDetailMedia.fromJson(e))
          .toList(),
      ingredients: (json["ingredients"] as List)
          .map((e) => IngredientModel.fromJson(e))
          .toList(),
      steps: (json["steps"] as List)
          .map((e) => StepModel.fromJson(e))
          .toList(),
    );
  }
}

class RecipeDetailMedia {
  final String url;
  final String type;

  RecipeDetailMedia({
    required this.url,
    required this.type,
  });

  factory RecipeDetailMedia.fromJson(Map<String, dynamic> json) {
    final dynamic rawType = json["type"];
    String type = "image";
    if (rawType is Map) {
      type = rawType["value"]?.toString() ?? "image";
    } else if (rawType != null) {
      type = rawType.toString();
    }

    return RecipeDetailMedia(
      url: json["url"] ?? "",
      type: type,
    );
  }
}

class IngredientModel {
  final int id;
  final String name;
  final String quantity;

  IngredientModel({
    required this.id,
    required this.name,
    required this.quantity,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      id: json["id"],
      name: json["name"],
      quantity: json["quantity"],
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
      order: json["order"],
      description: json["description"],
    );
  }
}
