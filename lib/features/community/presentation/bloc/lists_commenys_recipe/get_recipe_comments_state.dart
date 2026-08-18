import '../../../data/model/recipe_comments_list_model.dart';

abstract class GetRecipeCommentsState {}

class GetRecipeCommentsInitial extends GetRecipeCommentsState {}

class GetRecipeCommentsLoading extends GetRecipeCommentsState {}

class GetRecipeCommentsError extends GetRecipeCommentsState {
  final String message;
  GetRecipeCommentsError(this.message);
}

class GetRecipeCommentsSuccess extends GetRecipeCommentsState {
  final List<RecipeCommentItem> comments;
  final bool hasMore;
  final int currentPage;
  final bool isLoadingMore;

  GetRecipeCommentsSuccess({
    required this.comments,
    required this.hasMore,
    required this.currentPage,
    this.isLoadingMore = false,
  });
}