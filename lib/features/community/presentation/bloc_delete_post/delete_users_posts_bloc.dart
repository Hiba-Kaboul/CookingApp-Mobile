import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/api/delete_post_api.dart';
import 'delete_users_posts_event.dart';
import 'delete_users_posts_state.dart';

class DeleteUsersPostsBloc
    extends Bloc<DeleteUsersPostsEvent, DeleteUsersPostsState> {
  final DeletePostApi deletePostApi;

  DeleteUsersPostsBloc(this.deletePostApi) : super(DeleteUsersPostsInitial()) {
    on<DeletePostsEvent>((event, emit) async {
      emit(DeleteUsersPostsLoading());

      try {
        final isDeleted = await deletePostApi.deletePostApi(event.id);

        if (isDeleted) {
          emit(DeleteUsersPostsSuccess("تم الحذف بنجاح"));
        } else {
          emit(DeleteUsersPostsError("حدث خطأ أثناء الحذف"));
        }
      } catch (e) {
        emit(DeleteUsersPostsError(e.toString()));
      }
    });
  }
}
