import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/api/add_recipe_comment_api.dart';
import 'add_recipe_comment_event.dart';
import 'add_recipe_comment_state.dart';

class AddRecipeCommentBloc
    extends Bloc<AddRecipeCommentEvent, AddRecipeCommentState> {
  final AddRecipeCommentApi api;

  AddRecipeCommentBloc(this.api) : super(AddRecipeCommentInitial()) {
    on<SubmitRecipeCommentEvent>(_onSubmit);
  }

  Future<void> _onSubmit(
    SubmitRecipeCommentEvent event,
    Emitter<AddRecipeCommentState> emit,
  ) async {
    emit(AddRecipeCommentLoading());
    try {
      final result = await api.addComment(
        recipeId: event.recipeId,
        body: event.body,
      );
      emit(AddRecipeCommentSuccess(result));
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'حدث خطأ أثناء إضافة التعليق';
      emit(AddRecipeCommentFailure(message.toString()));
    } catch (e) {
      emit(AddRecipeCommentFailure('حدث خطأ أثناء إضافة التعليق'));
    }
  }
}