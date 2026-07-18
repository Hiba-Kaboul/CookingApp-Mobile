import 'dart:io';

class CreatePostRequestModel {
  final String title;
  final String description;
  final int categoryId;
  final int durationMinutes;
  final int servings;

  final List<StepRequestModel> steps;
  final List<IngredientRequestModel> ingredients;

  final List<File> media;

  CreatePostRequestModel({
    required this.title,
    required this.description,
    required this.categoryId,
    required this.durationMinutes,
    required this.servings,
    required this.steps,
    required this.ingredients,
    required this.media,
  });
}

class StepRequestModel {
  final int order;
  final String description;

  StepRequestModel({
    required this.order,
    required this.description,
  });
}

class IngredientRequestModel {
  final String name;
  final String quantity;

  IngredientRequestModel({
    required this.name,
    required this.quantity,
  });
}