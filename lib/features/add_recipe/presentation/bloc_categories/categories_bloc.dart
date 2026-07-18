import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/api/categories_api.dart';
import 'categories_event.dart';
import 'categories_state.dart';

class CategoriesBloc
    extends Bloc<CategoriesEvent, CategoriesState> {
  final CategoriesApi api;

  CategoriesBloc(this.api)
      : super(CategoriesInitial()) {
    on<GetCategoriesEvent>(getCategories);
  }

  Future<void> getCategories(
    GetCategoriesEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(CategoriesLoading());

    try {
      final response = await api.getCategories();

      emit(
        CategoriesSuccess(response.data),
      );
    } catch (e) {
      emit(
        CategoriesError(e.toString()),
      );
    }
  }
}