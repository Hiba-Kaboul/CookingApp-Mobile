import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/api/my_saved_posts_api.dart';
import 'saved_posts_event.dart';
import 'saved_posts_state.dart';



class SavedItemsBloc extends Bloc<SavedItemsEvent, SavedItemsState> {
  final SavedItemsApi api;

  SavedItemsBloc(this.api) : super(SavedItemsInitial()) {
    on<GetSavedItemsEvent>(_onGetSavedItems);
  }

  Future<void> _onGetSavedItems(
    GetSavedItemsEvent event,
    Emitter<SavedItemsState> emit,
  ) async {
    emit(SavedItemsLoading());
    try {
      final result = await api.getSavedItems();
      emit(SavedItemsSuccess(result.data));
    } catch (e) {
      emit(SavedItemsError('حدث خطأ أثناء تحميل المحفوظات'));
    }
  }
}