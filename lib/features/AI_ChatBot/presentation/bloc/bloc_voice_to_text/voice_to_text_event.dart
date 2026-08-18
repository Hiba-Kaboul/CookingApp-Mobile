// presentation/bloc/bloc_voice_to_text/voice_to_text_event.dart
abstract class VoiceToTextEvent {}

class VoiceRecordingStarted extends VoiceToTextEvent {}

class VoiceRecordingStopped extends VoiceToTextEvent {}