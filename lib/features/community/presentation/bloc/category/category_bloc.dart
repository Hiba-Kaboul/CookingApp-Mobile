import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/features/community/data/api/category_api.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryApi categoryApi;

  CategoryBloc(this.categoryApi) : super(CategoryInitial()) {
    on<GetCategoriesEvent>((event, emit) async {
      emit(CategoryLoading());

      try {
        final categories = await categoryApi.getCategories(event.cuisineId);

        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });
  }
}
