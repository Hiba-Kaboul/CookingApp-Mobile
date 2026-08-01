import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/api/recipes_posts_api.dart';
import 'recipes_event.dart';
import 'recipes_state.dart';

class RecipesBloc extends Bloc<RecipesEvent, RecipesState> {
  final RecipesApi api;

  RecipesBloc(this.api) : super(RecipesInitial()) {
    on<GetRecipesEvent>(_onGetRecipes);
    on<LoadMoreRecipesEvent>(_onLoadMore);
    on<UpdateRecipeLikeEvent>(_onUpdateLike);
    on<UpdateRecipeSaveEvent>(_onUpdateSave);
     on<UpdateRecipeCommentsEvent>(_onUpdateComments);
  }

  Future<void> _onGetRecipes(
    GetRecipesEvent event,
    Emitter<RecipesState> emit,
  ) async {
    emit(RecipesLoading());
    try {
      final result = await api.getRecipes(page: 1);
      emit(RecipesSuccess(
        recipes: result.data,
        hasMore: result.meta.currentPage < result.meta.lastPage,
        currentPage: result.meta.currentPage,
      ));
    } catch (e) {
      emit(RecipesError('حدث خطأ أثناء تحميل الوصفات'));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreRecipesEvent event,
    Emitter<RecipesState> emit,
  ) async {
    final currentState = state;
    if (currentState is! RecipesSuccess || !currentState.hasMore) return;

    try {
      final nextPage = currentState.currentPage + 1;
      final result = await api.getRecipes(page: nextPage);

      emit(RecipesSuccess(
        recipes: [...currentState.recipes, ...result.data],
        hasMore: result.meta.currentPage < result.meta.lastPage,
        currentPage: result.meta.currentPage,
      ));
    } catch (e) {
      // نضل بنفس الحالة عند الفشل
    }
  }

  void _onUpdateLike(
    UpdateRecipeLikeEvent event,
    Emitter<RecipesState> emit,
  ) {
    final currentState = state;
    if (currentState is RecipesSuccess) {
      final updatedRecipes = currentState.recipes.map((r) {
        if (r.id == event.recipeId) {
          return r.copyWith(
            isLiked: event.isLiked,
            likesCount: event.likesCount,
          );
        }
        return r;
      }).toList();

      emit(RecipesSuccess(
        recipes: updatedRecipes,
        hasMore: currentState.hasMore,
        currentPage: currentState.currentPage,
      ));
    }
  }

  void _onUpdateSave(
    UpdateRecipeSaveEvent event,
    Emitter<RecipesState> emit,
  ) {
    final currentState = state;
    if (currentState is RecipesSuccess) {
      final updatedRecipes = currentState.recipes.map((r) {
        if (r.id == event.recipeId) {
          return r.copyWith(isSaved: event.isSaved);
        }
        return r;
      }).toList();

      emit(RecipesSuccess(
        recipes: updatedRecipes,
        hasMore: currentState.hasMore,
        currentPage: currentState.currentPage,
      ));
    }
  }

  void _onUpdateComments(
  UpdateRecipeCommentsEvent event,
  Emitter<RecipesState> emit,
) {
  final currentState = state;

  if (currentState is RecipesSuccess) {
    final updatedRecipes = currentState.recipes.map((r) {
      if (r.id == event.recipeId) {
        return r.copyWith(
          commentsCount: event.commentsCount,
        );
      }
      return r;
    }).toList();

    emit(
      RecipesSuccess(
        recipes: updatedRecipes,
        hasMore: currentState.hasMore,
        currentPage: currentState.currentPage,
      ),
    );
  }
}
}