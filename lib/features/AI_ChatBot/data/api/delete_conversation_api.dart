// data/api/delete_conversation_api.dart
import 'package:dio/dio.dart';
import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';

class DeleteConversationApi {
  final Dio dio = Dio();

  Future<void> deleteConversation(int conversationId) async {
    final token = await TokenStorage.getToken();

    await dio.delete(
      "${ApiUrl.baseUrl}/chat/$conversationId",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
  }
}