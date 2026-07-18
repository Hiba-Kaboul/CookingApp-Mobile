import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../community/data/model/users_model.dart';
import '../../data/api/my_posts_view.dart';
import 'my_posts_event.dart';
import 'my_posts_state.dart';

class MyPostsBloc extends Bloc<MyPostsEvent, MyPostsState> {
  final MyPostsViewApi api;

  List<PostModel> allPosts = [];

  int currentPage = 1;
  bool hasMore = true;
  bool isLoading = false;

  MyPostsBloc(this.api) : super(MyPostsInitial()) {
    on<GetMyPostsEvent>(_getPosts);
    on<LoadMoreMyPostsEvent>(_getPosts);
  }

  Future<void> _getPosts(
    MyPostsEvent event,
    Emitter<MyPostsState> emit,
  ) async {
    if (event is GetMyPostsEvent) {
      currentPage = 1;
      allPosts.clear();
      hasMore = true;

      emit(MyPostsLoading());
    }

    if (isLoading || !hasMore) return;

    isLoading = true;

    try {
      final result = await api.getMyPosts(currentPage);

      final newPosts = result.data.where(
        (post) => !allPosts.any((e) => e.id == post.id),
      );

      allPosts.addAll(newPosts);

      hasMore = currentPage < result.meta.lastPage;

      if (hasMore) {
        currentPage++;
      }

      emit(MyPostsSuccess(allPosts, hasMore));
    } catch (e) {
      emit(MyPostsError(e.toString()));
    }

    isLoading = false;
  }
}