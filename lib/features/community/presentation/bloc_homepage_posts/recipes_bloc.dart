import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/api/recipes_api.dart';
import 'recipes_event.dart';
import 'recipes_state.dart';

class RecipesBloc extends Bloc<RecipesEvent, RecipesState> {
  final RecipesApi api;

  RecipesBloc(this.api) : super(RecipesInitial()) {
    on<GetRecipesEvent>(_onGetRecipes);
    on<LoadMoreRecipesEvent>(_onLoadMore);
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
}