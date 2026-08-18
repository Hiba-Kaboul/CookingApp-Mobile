// presentation/bloc/bloc_search_recipes/search_recipes_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/features/community/presentation/bloc/bloc_search_recipe/search_recipe_state.dart';
import '../../../data/api/search_recipe_api.dart';

import 'search_recipe_event.dart';


class SearchRecipesBloc extends Bloc<SearchRecipesEvent, SearchRecipesState> {
  final SearchRecipesApi api;
  String _latestQuery = '';

  SearchRecipesBloc(this.api) : super(SearchRecipesInitial()) {
    on<SearchRecipesQueryChanged>(_onQueryChanged);
  }

  Future<void> _onQueryChanged(
    SearchRecipesQueryChanged event,
    Emitter<SearchRecipesState> emit,
  ) async {
    final query = event.query.trim();
    _latestQuery = query;

    if (query.isEmpty) {
      emit(SearchRecipesInitial());
      return;
    }

    emit(SearchRecipesLoading());

    // debounce بسيط: منستنى شوي قبل ما نرسل الريكوست
    await Future.delayed(const Duration(milliseconds: 400));
    if (_latestQuery != query) return; // المستخدم كمّل يكتب، هاد الطلب صار قديم

    try {
      final response = await api.searchRecipes(query);
      if (_latestQuery != query) return;

      if (response.data.isEmpty) {
        emit(SearchRecipesEmpty());
      } else {
        emit(SearchRecipesLoaded(response.data));
      }
    } catch (e) {
      if (_latestQuery != query) return;
      emit(SearchRecipesError("صار في خطأ، حاول كمان مرة"));
    }
  }
}