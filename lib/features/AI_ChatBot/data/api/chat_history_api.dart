// data/api/chat_history_api.dart
import 'package:dio/dio.dart';
import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../model/chat_history_model.dart';

class ChatHistoryApi {
  final Dio dio = Dio();

  Future<ChatHistoryResponse> getHistory(int conversationId) async {
    final token = await TokenStorage.getToken();

    final response = await dio.get(
      "${ApiUrl.baseUrl}/chat/$conversationId/history",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return ChatHistoryResponse.fromMap(response.data);
  }
}