
abstract class DeleteUsersPostsState {}

class DeleteUsersPostsInitial extends DeleteUsersPostsState {}

class DeleteUsersPostsLoading extends DeleteUsersPostsState {}

class DeleteUsersPostsSuccess extends DeleteUsersPostsState {
  final String message; 

  DeleteUsersPostsSuccess(this.message);
}

class DeleteUsersPostsError extends DeleteUsersPostsState {
  final String message;

  DeleteUsersPostsError(this.message);
}
