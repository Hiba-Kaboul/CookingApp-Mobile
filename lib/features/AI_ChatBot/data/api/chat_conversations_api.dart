// data/api/conversations_api.dart
import 'package:dio/dio.dart';
import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../model/chat_conversation_model.dart';

class ConversationsApi {
  final Dio dio = Dio();

  Future<ConversationsResponse> getConversations() async {
    final token = await TokenStorage.getToken();

    final response = await dio.get(
      "${ApiUrl.baseUrl}/chat",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return ConversationsResponse.fromMap(response.data);
  }
}