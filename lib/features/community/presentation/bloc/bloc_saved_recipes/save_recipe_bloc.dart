import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/api/save_recipe_api.dart';
import 'save_recipe_event.dart';
import 'save_recipe_state.dart';

class SaveRecipeBloc extends Bloc<SaveRecipeEvent, SaveRecipeState> {
  final SaveRecipeApi api;

  SaveRecipeBloc(this.api) : super(SaveRecipeInitial()) {
    on<ToggleSaveRecipeEvent>(_onToggleSave);
  }

  Future<void> _onToggleSave(
    ToggleSaveRecipeEvent event,
    Emitter<SaveRecipeState> emit,
  ) async {
    try {
      final result = await api.saveRecipe(event.recipeId);
      emit(SaveRecipeSuccess(
        recipeId: event.recipeId,
        saved: result.saved,
        savesCount: result.savesCount,
      ));
    } catch (e) {
      emit(SaveRecipeFailure('حدث خطأ أثناء الحفظ'));
    }
  }
}