

abstract class CreatePostState {}

class CreatePostInitial extends CreatePostState {}

class CreatePostLoading extends CreatePostState {}

class CreatePostSuccess extends CreatePostState {
  final String message;

  CreatePostSuccess({
    required this.message,
  });
}

class CreatePostError extends CreatePostState {
  final String message;

  CreatePostError({
    required this.message,
  });
}