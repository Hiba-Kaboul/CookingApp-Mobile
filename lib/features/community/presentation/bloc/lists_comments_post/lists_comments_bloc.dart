import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/api/list_comments_api.dart';
import '../../../data/model/comments_list_model.dart';
import 'lists_comments_event.dart';
import 'lists_comments_state.dart';


class GetCommentsBloc extends Bloc<GetCommentsEvent, GetCommentsState> {
  final GetCommentsApi api;

  List<CommentItemModel> allComments = [];
  int currentPage = 1;
  bool hasMore = true;
  bool isLoading = false;

  GetCommentsBloc(this.api) : super(GetCommentsInitial()) {
    on<FetchCommentsEvent>(_onFetch);
    on<LoadMoreCommentsEvent>(_onLoadMore);
    on<RemoveCommentLocallyEvent>(_onRemoveLocally);
  }

  Future<void> _onFetch(
    FetchCommentsEvent event,
    Emitter<GetCommentsState> emit,
  ) async {
    currentPage = 1;
    allComments = [];
    hasMore = true;
    emit(GetCommentsLoading());

    await _fetchPage(event.postId, emit);
  }

  Future<void> _onLoadMore(
    LoadMoreCommentsEvent event,
    Emitter<GetCommentsState> emit,
  ) async {
    if (isLoading || !hasMore) return;
    emit(GetCommentsSuccess(allComments, hasMore, isLoadingMore: true));
    await _fetchPage(event.postId, emit);
  }

  Future<void> _fetchPage(
    int postId,
    Emitter<GetCommentsState> emit,
  ) async {
    isLoading = true;
    try {
      final result = await api.getComments(postId, page: currentPage);

      final newComments = result.data
          .where((newC) => !allComments.any((old) => old.id == newC.id))
          .toList();

      allComments.addAll(newComments);

      hasMore = currentPage < result.meta.lastPage;
      if (hasMore) currentPage++;

      emit(GetCommentsSuccess(List.from(allComments), hasMore));
    } catch (e) {
      emit(GetCommentsError(e.toString()));
    } finally {
      isLoading = false;
    }
  }

  void _onRemoveLocally(
  RemoveCommentLocallyEvent event,
  Emitter<GetCommentsState> emit,
) {
  allComments.removeWhere((c) => c.id == event.commentId);
  emit(GetCommentsSuccess(List.from(allComments), hasMore));
}
}