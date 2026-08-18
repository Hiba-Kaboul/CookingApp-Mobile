import '../../../data/model/share_post_model.dart';

abstract class SharePostState {}

class SharePostInitial extends SharePostState {}

class SharePostLoading extends SharePostState {}

class SharePostSuccess extends SharePostState {
  final int postId;
  final SharePostData data;
  final String platform;

  SharePostSuccess({
    required this.postId,
    required this.data,
    required this.platform,
  });
}

class SharePostError extends SharePostState {
  final String message;
  SharePostError(this.message);
}