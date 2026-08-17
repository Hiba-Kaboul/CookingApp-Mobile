// presentation/bloc/bloc_shopping_list/shopping_list_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api/shopping_list_api.dart';
import 'shopping_list_event.dart';
import 'shopping_list_state.dart';

class ShoppingListBloc extends Bloc<ShoppingListEvent, ShoppingListState> {
  final ShoppingListApi api;

  ShoppingListBloc(this.api) : super(ShoppingListInitial()) {
    on<GetShoppingListEvent>(_onGetList);
  }

  Future<void> _onGetList(
    GetShoppingListEvent event,
    Emitter<ShoppingListState> emit,
  ) async {
    emit(ShoppingListLoading());

    try {
      final response = await api.getShoppingList();

      if (response.data.isEmpty) {
        emit(ShoppingListEmpty());
      } else {
        emit(ShoppingListLoaded(response.data));
      }
    } catch (e) {
      emit(ShoppingListError("تعذر تحميل قائمة التسوق"));
    }
  }
}