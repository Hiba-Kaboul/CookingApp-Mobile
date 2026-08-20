// presentation/bloc/bloc_delete_shopping_items/delete_shopping_items_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api/delete_shopping_items_api.dart';
import '../../../../notification/data/fcm_service.dart';
import 'delete_shopping_items_event.dart';
import 'delete_shopping_items_state.dart';

class DeleteShoppingItemsBloc
    extends Bloc<DeleteShoppingItemsEvent, DeleteShoppingItemsState> {
  final DeleteShoppingItemsApi api;

  DeleteShoppingItemsBloc(this.api) : super(DeleteShoppingItemsInitial()) {
    on<DeleteSelectedShoppingItems>(_onDelete);
  }

  Future<void> _onDelete(
    DeleteSelectedShoppingItems event,
    Emitter<DeleteShoppingItemsState> emit,
  ) async {
    if (event.ids.isEmpty) {
      emit(DeleteShoppingItemsFailure("لم يتم تحديد أي عنصر"));
      return;
    }

    emit(DeleteShoppingItemsLoading());

    try {
      await api.deleteItems(event.ids);
      await FcmService.cancelShoppingReminders(event.ids);
      emit(DeleteShoppingItemsSuccess(event.ids));
    } catch (e) {
      emit(DeleteShoppingItemsFailure("تعذر حذف العناصر"));
    }
  }
}