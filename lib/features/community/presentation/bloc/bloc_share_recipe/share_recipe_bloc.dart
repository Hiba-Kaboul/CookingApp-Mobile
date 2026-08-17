import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api/share_recipe_api.dart';
import 'share_recipe_event.dart';
import 'share_recipe_state.dart';

class ShareRecipeBloc extends Bloc<ShareRecipeEvent, ShareRecipeState> {
  final ShareRecipeApi api;

  ShareRecipeBloc(this.api) : super(ShareRecipeInitial()) {
    on<ShareRecipeSubmitted>(_onShare);
  }

  Future<void> _onShare(
    ShareRecipeSubmitted event,
    Emitter<ShareRecipeState> emit,
  ) async {
    emit(ShareRecipeLoading());

    try {
      final result = await api.shareRecipe(
        recipeId: event.recipeId,
        platform: event.platform,
      );

      emit(ShareRecipeSuccess(
        recipeId: event.recipeId,
        data: result.data,
        platform: event.platform,
      ));
    } catch (e) {
      print('SHARE ERROR: $e');
      emit(ShareRecipeError('تعذر مشاركة الوصفة'));
    }
  }
}