import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/api/delete_comment_api.dart';
import 'delete_comment_event.dart';
import 'delete_comment_state.dart';

class DeleteCommentBloc extends Bloc<DeleteCommentEvent, DeleteCommentState> {
  final DeleteCommentApi api;

  DeleteCommentBloc(this.api) : super(DeleteCommentInitial()) {
    on<DeleteCommentRequested>(onDelete);
  }

  Future<void> onDelete(
    DeleteCommentRequested event,
    Emitter<DeleteCommentState> emit,
  ) async {
    emit(DeleteCommentLoading(event.commentId));
    try {
      await api.deleteComment(event.commentId);
      emit(DeleteCommentSuccess(event.commentId));
    } catch (e) {
      emit(DeleteCommentError(e.toString()));
    }
  }
}