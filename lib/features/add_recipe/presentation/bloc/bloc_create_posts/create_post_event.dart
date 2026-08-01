import '../../../data/models/create_post_request_model.dart';

abstract class CreatePostEvent {}

class CreatePostButtonPressed extends CreatePostEvent {
  final CreatePostRequestModel request;

  CreatePostButtonPressed({
    required this.request,
  });
}