// data/api/chat_start_api.dart
import 'package:dio/dio.dart';
import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../model/chat_start_model.dart';

class ChatStartApi {
  final Dio dio = Dio();

  Future<ChatStartResponse> startConversation(String message) async {
    final token = await TokenStorage.getToken();

    final response = await dio.post(
      "${ApiUrl.baseUrl}/chat/start",
      data: {
        "message": message,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return ChatStartResponse.fromMap(response.data);
  }
}