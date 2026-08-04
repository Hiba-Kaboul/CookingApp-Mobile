// presentation/bloc/bloc_voice_to_text/voice_to_text_state.dart
abstract class VoiceToTextState {}

class VoiceIdle extends VoiceToTextState {}

class VoiceRecording extends VoiceToTextState {}

class VoiceProcessing extends VoiceToTextState {}

class VoiceTranscribed extends VoiceToTextState {
  final String text;
  VoiceTranscribed(this.text);
}

class VoiceError extends VoiceToTextState {
  final String message;
  VoiceError(this.message);
}