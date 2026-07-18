import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/api/create_post_api.dart';
import 'create_post_event.dart';
import 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final CreatePostApi api;
// الحالة الابتدائية
  CreatePostBloc(this.api) : super(CreatePostInitial()) {
    // ال event يلي عندي وصل نفذ التابع  createPost
    on<CreatePostButtonPressed>(createPost);
  }

  Future<void> createPost(
    CreatePostButtonPressed event,
    Emitter<CreatePostState> emit,
  ) async {
//     عني قبل ما نبعت الطلب:
// غيّر الحالة إلى Loading.
// الواجهة رح تعرض Loading Indicator
    emit(CreatePostLoading());

    try {
      //هون استدعينا الـ API.  و event.request أرسلنا له

      final response = await api.createPost(event.request);

      emit(
        CreatePostSuccess(
          message: response.message,
        ),
      );
    } catch (e) {
      emit(
        CreatePostError(
          message: e.toString(),
        ),
      );
    }
  }
}
