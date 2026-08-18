import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/api/search_posts_api.dart';
import 'search_posts_event.dart';
import 'search_posts_state.dart';

class SearchPostsBloc extends Bloc<SearchPostsEvent, SearchPostsState> {
  final SearchPostsApi api;
  Timer? _debounce;

  SearchPostsBloc(this.api) : super(SearchPostsInitial()) {
    on<SearchPostsQueryChanged>(_onQueryChanged);
  }

  Future<void> _onQueryChanged(
    SearchPostsQueryChanged event,
    Emitter<SearchPostsState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      emit(SearchPostsInitial());
      return;
    }

    emit(SearchPostsLoading());

    // Debounce بسيط داخل الـ handler
    await Future.delayed(const Duration(milliseconds: 400));

    try {
      final result = await api.searchPosts(event.query.trim());
      if (result.data.isEmpty) {
        emit(SearchPostsEmpty());
      } else {
        emit(SearchPostsLoaded(result.data));
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'حدث خطأ، حاول مرة أخرى';
      emit(SearchPostsError(message.toString()));
   } catch (e) {
  print('SEARCH POSTS ERROR: $e');
  emit(SearchPostsError('حدث خطأ، حاول مرة أخرى'));
}
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}