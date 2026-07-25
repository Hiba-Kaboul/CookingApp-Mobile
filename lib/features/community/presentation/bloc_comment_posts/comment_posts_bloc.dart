import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/api/comment_api.dart';
import 'comment_posts_event.dart';
import 'comment_posts_state.dart';

class CommentPostsBloc extends Bloc<CommentPostsEvent, CommentPostsState> {
  final CommentApi commentApi;

  CommentPostsBloc(this.commentApi) : super(CommentsPostsInitial()) {
    on<CommentOnPostsEvent>(onCommentOnPost);
  }

  Future<void> onCommentOnPost(
    CommentOnPostsEvent event,
    Emitter<CommentPostsState> emit,
  ) async {
    emit(CommentsPostsLoading());
    try {
      final result = await commentApi.commentOnPost(event.id, event.body);
      emit(CommentsPostsSuccess(result));
    } catch (e) {
      emit(CommentsPostsError(e.toString()));
    }
  }
}