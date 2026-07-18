abstract class SaveUnlikePostsEvent {}

class ToggleSavePostEvent extends SaveUnlikePostsEvent {
  final int postId;

  ToggleSavePostEvent(this.postId);
}