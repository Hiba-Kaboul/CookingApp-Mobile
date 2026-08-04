// presentation/bloc/bloc_voice_to_text/voice_to_text_bloc.dart
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import '../../../data/api/voice_to_text_api.dart';
import 'voice_to_text_event.dart';
import 'voice_to_text_state.dart';

class VoiceToTextBloc extends Bloc<VoiceToTextEvent, VoiceToTextState> {
  final VoiceToTextApi api;
  final AudioRecorder _recorder = AudioRecorder();
  String? _filePath;

  VoiceToTextBloc(this.api) : super(VoiceIdle()) {
    on<VoiceRecordingStarted>(_onStart);
    on<VoiceRecordingStopped>(_onStop);
  }

  Future<void> _onStart(
    VoiceRecordingStarted event,
    Emitter<VoiceToTextState> emit,
  ) async {
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      emit(VoiceError("لا يوجد إذن للوصول للميكروفون"));
      return;
    }

    final dir = await getTemporaryDirectory();
    _filePath =
        "${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a";

    await _recorder.start(const RecordConfig(), path: _filePath!);
    emit(VoiceRecording());
  }

  Future<void> _onStop(
    VoiceRecordingStopped event,
    Emitter<VoiceToTextState> emit,
  ) async {
    final path = await _recorder.stop();
    if (path == null) {
      emit(VoiceError("تعذر تسجيل الصوت"));
      return;
    }

    emit(VoiceProcessing());

    try {
      final response = await api.transcribe(path);
      emit(VoiceTranscribed(response.text));
    } catch (e) {
       // 👇 مؤقت للتشخيص
    if (e is DioException) {
      print("VOICE ERROR STATUS: ${e.response?.statusCode}");
      print("VOICE ERROR DATA: ${e.response?.data}");
      print("VOICE FILE PATH: $path");
    } else {
      print("VOICE UNKNOWN ERROR: $e");
    }
      emit(VoiceError("تعذر تحويل الصوت لنص"));
    }
  }

  @override
  Future<void> close() {
    _recorder.dispose();
    return super.close();
  }
}