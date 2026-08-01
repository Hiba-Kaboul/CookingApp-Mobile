import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/features/community/data/api/recipe_api.dart';
import 'recipe_event.dart';
import 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeApi recipeApi;

  RecipeBloc(this.recipeApi) : super(RecipeInitial()) {
    on<GetRecipesEvent>(_getRecipes);
  }

  Future<void> _getRecipes(
    GetRecipesEvent event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());

    try {
      final recipes = await recipeApi.getRecipes(event.categoryId);

      emit(RecipeLoaded(recipes));
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }
}
