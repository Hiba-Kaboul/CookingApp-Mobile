abstract class SharePostEvent {}

class SharePostSubmitted extends SharePostEvent {
  final int postId;
  final String platform;

  SharePostSubmitted({
    required this.postId,
    required this.platform,
  });
}