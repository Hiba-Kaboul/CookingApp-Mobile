import '../../../data/model/share_recipe_model.dart';

abstract class ShareRecipeState {}
class ShareRecipeInitial extends ShareRecipeState {}
class ShareRecipeLoading extends ShareRecipeState {}

class ShareRecipeSuccess extends ShareRecipeState {
  final int recipeId;
  final ShareRecipeData data;
  final String platform;

  ShareRecipeSuccess({
    required this.recipeId,
    required this.data,
    required this.platform,
  });
}

class ShareRecipeError extends ShareRecipeState {
  final String message;
  ShareRecipeError(this.message);
}