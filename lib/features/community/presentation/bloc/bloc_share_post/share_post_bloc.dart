import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api/share_post_api.dart';
import 'share_post_event.dart';
import 'share_post_state.dart';

class SharePostBloc extends Bloc<SharePostEvent, SharePostState> {
  final SharePostApi api;

  SharePostBloc(this.api) : super(SharePostInitial()) {
    on<SharePostSubmitted>(_onShare);
  }

  Future<void> _onShare(
    SharePostSubmitted event,
    Emitter<SharePostState> emit,
  ) async {
    emit(SharePostLoading());

    try {
      final result = await api.sharePost(
        postId: event.postId,
        platform: event.platform,
      );

      emit(SharePostSuccess(
        postId: event.postId,
        data: result.data,
        platform: event.platform,
      ));
    } catch (e) {
      print('SHARE ERROR: $e');
      emit(SharePostError('تعذر مشاركة المنشور'));
    }
  }
}