// presentation/bloc/bloc_add_to_shopping_list/add_to_shopping_list_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/features/shopping_cart/presentation/bloc/bloc_add_to_shopping/add_shopping_list_event.dart';
import 'package:project2/features/shopping_cart/presentation/bloc/bloc_add_to_shopping/add_shopping_list_state.dart';

import '../../../data/api/add_shopping_list_api.dart';



class AddToShoppingListBloc
    extends Bloc<AddToShoppingListEvent, AddToShoppingListState> {
  final AddShoppingItemApi api;

  AddToShoppingListBloc(this.api) : super(AddToShoppingListInitial()) {
    on<AddIngredientsToShoppingList>(_onAddIngredients);
  }

  Future<void> _onAddIngredients(
    AddIngredientsToShoppingList event,
    Emitter<AddToShoppingListState> emit,
  ) async {
    if (event.ingredientIds.isEmpty) {
      emit(AddToShoppingListFailure("لم يتم تحديد أي مكوّن"));
      return;
    }

    emit(AddToShoppingListLoading());

    int successCount = 0;

    try {
      // نبعت نداء لكل عنصر محدد، واحد تلو الآخر
      for (final id in event.ingredientIds) {
        await api.addIngredient(id);
        successCount++;
      }

      emit(AddToShoppingListSuccess(successCount));
    } catch (e) {
      emit(AddToShoppingListFailure(
        "تمت إضافة $successCount من ${event.ingredientIds.length}، وصار خطأ بالباقي",
      ));
    }
  }
}