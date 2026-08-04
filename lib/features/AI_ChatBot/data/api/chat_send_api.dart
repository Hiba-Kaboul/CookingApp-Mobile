// data/api/chat_send_api.dart
import 'package:dio/dio.dart';
import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../model/chat_send_model.dart';

class ChatSendApi {
  final Dio dio = Dio();

  Future<ChatSendResponse> sendMessage({
    required int conversationId,
    required String message,
  }) async {
    final token = await TokenStorage.getToken();

    final response = await dio.post(
      "${ApiUrl.baseUrl}/chat/$conversationId/send",
      data: {
        "message": message,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return ChatSendResponse.fromMap(response.data);
  }
}