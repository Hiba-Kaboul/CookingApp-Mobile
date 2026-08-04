import 'package:project2/features/admin_recipe_detail/data/models/admin_recipe_detail_model.dart';

abstract class AdminRecipeDetailState {}

class AdminRecipeDetailInitial extends AdminRecipeDetailState {}

class AdminRecipeDetailLoading extends AdminRecipeDetailState {}

class AdminRecipeDetailLoaded extends AdminRecipeDetailState {
  final AdminRecipeDetailModel recipe;

  AdminRecipeDetailLoaded(this.recipe);
}

class AdminRecipeDetailError extends AdminRecipeDetailState {
  final String message;

  AdminRecipeDetailError(this.message);
}
