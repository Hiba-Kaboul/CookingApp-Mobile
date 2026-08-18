class RecipesResponse {
  final List<Recipe> data;
  final Meta meta;

  RecipesResponse({required this.data, required this.meta});

  factory RecipesResponse.fromMap(Map<String, dynamic> map) {
    return RecipesResponse(
      data: List<Recipe>.from(
        (map['data'] as List).map((e) => Recipe.fromMap(e)),
      ),
      meta: Meta.fromMap(map['meta']),
    );
  }
}

class Recipe {
  final int id;
  final String name;
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final List<RecipeMedia> media;
  final int prepTime;
  final int cookTime;
  final int servings;
  final RecipeLabelValue difficulty;
  final RecipeLabelValue status;
  final RecipeCategory category;
  final RecipeUser user;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final bool isSaved;
  final String createdAt;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.media,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.difficulty,
    required this.status,
    required this.category,
    required this.user,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
    required this.isSaved,
    required this.createdAt,
  });

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      ingredients: List<String>.from(map['ingredients'] ?? []),
      steps: List<String>.from(map['steps'] ?? []),
      media: List<RecipeMedia>.from(
        (map['media'] as List? ?? []).map((e) => RecipeMedia.fromMap(e)),
      ),
      prepTime: map['prep_time'] ?? 0,
      cookTime: map['cook_time'] ?? 0,
      servings: map['servings'] ?? 0,
      difficulty: RecipeLabelValue.fromMap(map['difficulty']),
      status: RecipeLabelValue.fromMap(map['status']),
      category: RecipeCategory.fromMap(map['category']),
      user: RecipeUser.fromMap(map['user']),
      likesCount: map['likes_count'] ?? 0,
      commentsCount: map['comments_count'] ?? 0,
      isLiked: map['is_liked'] ?? false,
      isSaved: map['is_saved'] ?? false,
      createdAt: map['created_at'] ?? '',
    );
  }

  Recipe copyWith({
    int? id,
    String? name,
    String? description,
    List<String>? ingredients,
    List<String>? steps,
    List<RecipeMedia>? media,
    int? prepTime,
    int? cookTime,
    int? servings,
    RecipeLabelValue? difficulty,
    RecipeLabelValue? status,
    RecipeCategory? category,
    RecipeUser? user,
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
    bool? isSaved,
    String? createdAt,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      media: media ?? this.media,
      prepTime: prepTime ?? this.prepTime,
      cookTime: cookTime ?? this.cookTime,
      servings: servings ?? this.servings,
      difficulty: difficulty ?? this.difficulty,
      status: status ?? this.status,
      category: category ?? this.category,
      user: user ?? this.user,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
}

class RecipeMedia {
  final int id;
  final String type;
  final String url;
  final int order;

  RecipeMedia({
    required this.id,
    required this.type,
    required this.url,
    required this.order,
  });

  factory RecipeMedia.fromMap(Map<String, dynamic> map) {
    return RecipeMedia(
      id: map['id'],
      type: map['type']?['value'] ?? '',
      url: map['url'] ?? '',
      order: map['order'] ?? 0,
    );
  }
}

class RecipeLabelValue {
  final String value;
  final String label;

  RecipeLabelValue({required this.value, required this.label});

  factory RecipeLabelValue.fromMap(Map<String, dynamic> map) {
    return RecipeLabelValue(
      value: map['value'] ?? '',
      label: map['label'] ?? '',
    );
  }
}

class RecipeCategory {
  final int id;
  final String name;
  final RecipeCuisine cuisine;

  RecipeCategory({required this.id, required this.name, required this.cuisine});

  factory RecipeCategory.fromMap(Map<String, dynamic> map) {
    return RecipeCategory(
      id: map['id'],
      name: map['name'] ?? '',
      cuisine: RecipeCuisine.fromMap(map['cuisine']),
    );
  }
}

class RecipeCuisine {
  final int id;
  final String name;

  RecipeCuisine({required this.id, required this.name});

  factory RecipeCuisine.fromMap(Map<String, dynamic> map) {
    return RecipeCuisine(id: map['id'], name: map['name'] ?? '');
  }
}

class RecipeUser {
  final int id;
  final String name;
  final String? avatar; // أضفنا الـ avatar

  RecipeUser({required this.id, required this.name, this.avatar});

  factory RecipeUser.fromMap(Map<String, dynamic> map) {
    return RecipeUser(
      id: map['id'],
      name: map['name'] ?? '',
      avatar: map['avatar'], // جلب الـ avatar من الـ JSON
    );
  }
}

class Meta {
  final int currentPage;
  final int lastPage;
  final int total;

  Meta({required this.currentPage, required this.lastPage, required this.total});

  factory Meta.fromMap(Map<String, dynamic> map) {
    return Meta(
      currentPage: map['current_page'] ?? 1,
      lastPage: map['last_page'] ?? 1,
      total: map['total'] ?? 0,
    );
  }
}