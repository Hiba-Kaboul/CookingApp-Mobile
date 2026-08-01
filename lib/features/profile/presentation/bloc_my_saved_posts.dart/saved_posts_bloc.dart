import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/api/my_saved_posts_api.dart';
import 'saved_posts_event.dart';
import 'saved_posts_state.dart';

class SavedPostsBloc extends Bloc<SavedPostsEvent, SavedPostsState> {
  final SavedPostsApi api;

  SavedPostsBloc(this.api) : super(SavedPostsInitial()) {
    on<GetSavedPostsEvent>(_onGetSavedPosts);
    on<LoadMoreSavedPostsEvent>(_onLoadMore);
  }

  Future<void> _onGetSavedPosts(
    GetSavedPostsEvent event,
    Emitter<SavedPostsState> emit,
  ) async {
    emit(SavedPostsLoading());
    try {
      final posts = await api.getSavedPosts(page: 1);
      emit(SavedPostsSuccess(
        posts: posts,
        hasMore: posts.isNotEmpty,
        currentPage: 1,
      ));
    } catch (e) {
      emit(SavedPostsError('حدث خطأ أثناء تحميل المحفوظات'));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreSavedPostsEvent event,
    Emitter<SavedPostsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! SavedPostsSuccess || !currentState.hasMore) return;

    try {
      final nextPage = currentState.currentPage + 1;
      final newPosts = await api.getSavedPosts(page: nextPage);

      emit(SavedPostsSuccess(
        posts: [...currentState.posts, ...newPosts],
        hasMore: newPosts.isNotEmpty,
        currentPage: nextPage,
      ));
    } catch (e) {
      // بالفشل نضل بنفس الحالة الحالية بدون تغيير
    }
  }
}