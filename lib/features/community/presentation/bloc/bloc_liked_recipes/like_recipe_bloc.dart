import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/api/like_recipe_api.dart';
import 'like_recipe_event.dart';
import 'like_recipe_state.dart';

class LikeRecipeBloc extends Bloc<LikeRecipeEvent, LikeRecipeState> {
  final LikeRecipeApi api;

  LikeRecipeBloc(this.api) : super(LikeRecipeInitial()) {
    on<ToggleLikeRecipeEvent>(_onToggleLike);
  }

  Future<void> _onToggleLike(
    ToggleLikeRecipeEvent event,
    Emitter<LikeRecipeState> emit,
  ) async {
    try {
      final result = await api.likeRecipe(event.recipeId);
      emit(LikeRecipeSuccess(
        recipeId: event.recipeId,
        liked: result.liked,
        likesCount: result.likesCount,
      ));
    } catch (e) {
      emit(LikeRecipeFailure('حدث خطأ أثناء الإعجاب'));
    }
  }
}