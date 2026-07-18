import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/features/community/presentation/bloc_saved_posts/saved_unsaved_posts_state.dart';
import '../../data/api/save_unsave_posts_api.dart';
import 'saved_unsaved_posts_event.dart';

class SaveUnlikePostsBloc
    extends Bloc<SaveUnlikePostsEvent, SaveUnlikePostsState> {

  final SaveUnsavePostsApi api;

  SaveUnlikePostsBloc(this.api)
      : super(SaveUnlikePostsInitial()) {

    on<ToggleSavePostEvent>(toggleSave);
  }

  Future<void> toggleSave(
    ToggleSavePostEvent event,
    Emitter<SaveUnlikePostsState> emit,
  ) async {

    emit(SaveUnlikePostsLoading());

    try {

      final result =
          await api.save_unsave_PostApi(event.postId);

      emit(
        SaveUnlikePostsSuccess(
          postId: event.postId,
          isSaved: result.data.isSaved,
          savesCount: result.data.savesCount,
        ),
      );

    } catch (e) {

      emit(
        SaveUnlikePostsError(e.toString()),
      );

    }
  }
}