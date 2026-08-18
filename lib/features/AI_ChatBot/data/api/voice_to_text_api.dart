// data/api/voice_to_text_api.dart
import 'package:dio/dio.dart';
import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../model/voice_to_text_model.dart';

class VoiceToTextApi {
  final Dio dio = Dio();

  Future<VoiceToTextResponse> transcribe(String audioFilePath) async {
    final token = await TokenStorage.getToken();

    final formData = FormData.fromMap({
      "audio": await MultipartFile.fromFile(audioFilePath),
    });

    final response = await dio.post(
      "${ApiUrl.baseUrl}/chat/voice",
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          // filename: "voice_record.m4a",
        },
      ),
    );

    return VoiceToTextResponse.fromMap(response.data);
  }
}