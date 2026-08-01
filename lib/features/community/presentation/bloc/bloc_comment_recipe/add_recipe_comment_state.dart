import '../../../data/model/add_recipe_comment_model.dart';

abstract class AddRecipeCommentState {}

class AddRecipeCommentInitial extends AddRecipeCommentState {}

class AddRecipeCommentLoading extends AddRecipeCommentState {}

class AddRecipeCommentSuccess extends AddRecipeCommentState {
  final AddRecipeComment comment;
  AddRecipeCommentSuccess(this.comment);
}

class AddRecipeCommentFailure extends AddRecipeCommentState {
  final String message;
  AddRecipeCommentFailure(this.message);
}