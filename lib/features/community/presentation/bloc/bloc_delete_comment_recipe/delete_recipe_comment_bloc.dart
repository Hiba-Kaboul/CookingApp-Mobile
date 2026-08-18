import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api/delete_recipe_comment_api.dart';
import 'delete_recipe_comment_event.dart';
import 'delete_recipe_comment_state.dart'; // تأكد من المسار الصحيح للـ API

class DeleteRecipeCommentBloc extends Bloc<DeleteRecipeCommentEvent, DeleteRecipeCommentState> {
  final DeleteRecipeCommentApi api;

  DeleteRecipeCommentBloc(this.api) : super(DeleteRecipeCommentInitial()) {
    on<DeleteRecipeCommentRequested>(_onDelete);
  }

  Future<void> _onDelete(
    DeleteRecipeCommentRequested event,
    Emitter<DeleteRecipeCommentState> emit,
  ) async {
    emit(DeleteRecipeCommentLoading(event.commentId));
    try {
      await api.deleteComment(event.commentId);
      emit(DeleteRecipeCommentSuccess(event.commentId));
    } catch (e) {
      emit(DeleteRecipeCommentError(e.toString()));
    }
  }
}