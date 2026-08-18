import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/features/recipe_detail/data/api/recipe_detail_api.dart';
import 'package:project2/features/recipe_detail/presentation/bloc/recipe_detail_event.dart';
import 'package:project2/features/recipe_detail/presentation/bloc/recipe_detail_state.dart';

class RecipeDetailBloc
    extends Bloc<RecipeDetailEvent, RecipeDetailState> {

  final RecipeDetailApi api;

  RecipeDetailBloc(this.api)
      : super(RecipeDetailInitial()) {

    on<GetRecipeDetail>(_getRecipe);
  }

  Future<void> _getRecipe(
      GetRecipeDetail event,
      Emitter<RecipeDetailState> emit) async {

    emit(RecipeDetailLoading());

    try {

      final recipe = await api.getRecipeDetail(event.id);

      emit(RecipeDetailLoaded(recipe));

    } catch (e) {

      emit(RecipeDetailError(e.toString()));

    }
  }
}