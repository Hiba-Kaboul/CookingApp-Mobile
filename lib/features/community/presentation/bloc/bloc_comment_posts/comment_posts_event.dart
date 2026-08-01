abstract class CommentPostsEvent {}

class CommentOnPostsEvent extends CommentPostsEvent {
  final int id;
  final String body;

  CommentOnPostsEvent(this.id, this.body);
}