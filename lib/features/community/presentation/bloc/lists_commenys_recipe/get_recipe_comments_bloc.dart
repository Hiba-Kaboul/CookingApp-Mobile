import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/api/get_recipe_comments_api.dart';
import 'get_recipe_comments_event.dart';
import 'get_recipe_comments_state.dart';

class GetRecipeCommentsBloc
    extends Bloc<GetRecipeCommentsEvent, GetRecipeCommentsState> {
  final GetRecipeCommentsApi api;

  GetRecipeCommentsBloc(this.api) : super(GetRecipeCommentsInitial()) {
    on<FetchRecipeCommentsEvent>(_onFetch);
    on<LoadMoreRecipeCommentsEvent>(_onLoadMore);
    on<AddCommentLocallyEvent>(_onAddLocally);
    on<RemoveRecipeCommentLocallyEvent>(_onRemoveLocally);
  }

  Future<void> _onFetch(
    FetchRecipeCommentsEvent event,
    Emitter<GetRecipeCommentsState> emit,
  ) async {
    emit(GetRecipeCommentsLoading());
    try {
      final result = await api.getComments(recipeId: event.recipeId, page: 1);
      emit(GetRecipeCommentsSuccess(
        comments: result.data,
        hasMore: result.meta.currentPage < result.meta.lastPage,
        currentPage: result.meta.currentPage,
      ));
    } catch (e) {
      emit(GetRecipeCommentsError('حدث خطأ أثناء تحميل التعليقات'));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreRecipeCommentsEvent event,
    Emitter<GetRecipeCommentsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! GetRecipeCommentsSuccess ||
        !currentState.hasMore ||
        currentState.isLoadingMore) return;

    emit(GetRecipeCommentsSuccess(
      comments: currentState.comments,
      hasMore: currentState.hasMore,
      currentPage: currentState.currentPage,
      isLoadingMore: true,
    ));

    try {
      final nextPage = currentState.currentPage + 1;
      final result = await api.getComments(
        recipeId: event.recipeId,
        page: nextPage,
      );

      emit(GetRecipeCommentsSuccess(
        comments: [...currentState.comments, ...result.data],
        hasMore: result.meta.currentPage < result.meta.lastPage,
        currentPage: result.meta.currentPage,
      ));
    } catch (e) {
      emit(GetRecipeCommentsSuccess(
        comments: currentState.comments,
        hasMore: currentState.hasMore,
        currentPage: currentState.currentPage,
        isLoadingMore: false,
      ));
    }
  }

  void _onAddLocally(
    AddCommentLocallyEvent event,
    Emitter<GetRecipeCommentsState> emit,
  ) {
    final currentState = state;
    if (currentState is GetRecipeCommentsSuccess) {
      emit(GetRecipeCommentsSuccess(
        comments: [event.comment, ...currentState.comments],
        hasMore: currentState.hasMore,
        currentPage: currentState.currentPage,
      ));
    }
  }

  void _onRemoveLocally(
    RemoveRecipeCommentLocallyEvent event,
    Emitter<GetRecipeCommentsState> emit,
  ) {
    final currentState = state;
    if (currentState is GetRecipeCommentsSuccess) {
      final updated = currentState.comments
          .where((c) => c.id != event.commentId)
          .toList();
      emit(GetRecipeCommentsSuccess(
        comments: updated,
        hasMore: currentState.hasMore,
        currentPage: currentState.currentPage,
      ));
    }
  }
}