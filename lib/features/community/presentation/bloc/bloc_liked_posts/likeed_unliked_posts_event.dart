abstract class LikeUnlikeUsersPostsEvent {}

class ToggleLikePostEvent extends LikeUnlikeUsersPostsEvent {
  final int postId;

  ToggleLikePostEvent(this.postId);
}