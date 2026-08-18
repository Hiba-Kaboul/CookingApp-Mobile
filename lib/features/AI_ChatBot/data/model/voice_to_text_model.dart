// data/model/voice_to_text_model.dart
class VoiceToTextResponse {
  final int status;
  final String message;
  final String text;

  VoiceToTextResponse({
    required this.status,
    required this.message,
    required this.text,
  });

  factory VoiceToTextResponse.fromMap(Map<String, dynamic> map) {
    return VoiceToTextResponse(
      status: map['status'] ?? 0,
      message: map['message'] ?? '',
      text: map['data']?['text'] ?? '',
    );
  }
}