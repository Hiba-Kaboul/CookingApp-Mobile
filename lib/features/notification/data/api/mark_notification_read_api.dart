import 'package:dio/dio.dart';

import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';

class MarkNotificationReadApi {
  final Dio dio = Dio();

  Future<void> markNotificationRead(String id) async {
    final token = await TokenStorage.getToken();

    await dio.patch(
      "${ApiUrl.baseUrl}/notifications/$id/read",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );
  }
}
