

abstract class DeleteUsersPostsEvent {}
class DeletePostsEvent extends DeleteUsersPostsEvent{
  final int id;

  DeletePostsEvent(this.id);
}