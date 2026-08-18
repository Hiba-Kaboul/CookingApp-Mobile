import '../../../data/model/recipe_comments_list_model.dart';

abstract class GetRecipeCommentsEvent {}

class FetchRecipeCommentsEvent extends GetRecipeCommentsEvent {
  final int recipeId;
  FetchRecipeCommentsEvent(this.recipeId);
}

class LoadMoreRecipeCommentsEvent extends GetRecipeCommentsEvent {
  final int recipeId;
  LoadMoreRecipeCommentsEvent(this.recipeId);
}

class AddCommentLocallyEvent extends GetRecipeCommentsEvent {
  final RecipeCommentItem comment;
  AddCommentLocallyEvent(this.comment);
}

class RemoveRecipeCommentLocallyEvent extends GetRecipeCommentsEvent {
  final int commentId;
  RemoveRecipeCommentLocallyEvent(this.commentId);
}