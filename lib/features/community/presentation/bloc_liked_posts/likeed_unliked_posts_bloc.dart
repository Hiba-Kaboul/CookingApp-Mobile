import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/api/like_unlike_posts_api.dart';
import 'likeed_unliked_posts_event.dart';
import 'likeed_unliked_posts_state.dart';
class LikeUnlikePostsBloc
    extends Bloc<LikeUnlikeUsersPostsEvent, LikeUnlikePostsState> {

  final LikeUnlikePostsApi api;

  LikeUnlikePostsBloc(this.api)
      : super(LikeUnlikePostsInitial()) {

    on<ToggleLikePostEvent>(toggleLike);
  }

  Future<void> toggleLike(
      ToggleLikePostEvent event,
      Emitter<LikeUnlikePostsState> emit,
  ) async {

    emit(LikeUnlikePostsLoading());

    try {

      final result =
          await api.like_unlike_PostApi(event.postId);

      emit(
        LikeUnlikePostsSuccess(
          liked: result.data.liked,
          likesCount: result.data.likesCount,
          postId: event.postId,
        ),
      );

    } catch (e) {

      emit(
        LikeUnlikePostsError(e.toString()),
      );

    }
  }
}