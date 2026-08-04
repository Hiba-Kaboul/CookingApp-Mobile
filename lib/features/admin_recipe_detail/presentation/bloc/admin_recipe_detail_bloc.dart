import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/features/admin_recipe_detail/data/api/admin_recipe_detail_api.dart';
import 'package:project2/features/admin_recipe_detail/presentation/bloc/admin_recipe_detail_event.dart';
import 'package:project2/features/admin_recipe_detail/presentation/bloc/admin_recipe_detail_state.dart';

class AdminRecipeDetailBloc
    extends Bloc<AdminRecipeDetailEvent, AdminRecipeDetailState> {
  final AdminRecipeDetailApi api;

  AdminRecipeDetailBloc(this.api) : super(AdminRecipeDetailInitial()) {
    on<GetAdminRecipeDetail>(_getRecipe);
  }

  Future<void> _getRecipe(
    GetAdminRecipeDetail event,
    Emitter<AdminRecipeDetailState> emit,
  ) async {
    emit(AdminRecipeDetailLoading());

    try {
      final recipe = await api.getRecipeDetail(event.id);
      emit(AdminRecipeDetailLoaded(recipe));
    } catch (e) {
      emit(AdminRecipeDetailError(e.toString()));
    }
  }
}
