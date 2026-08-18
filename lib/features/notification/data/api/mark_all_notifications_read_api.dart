import 'package:dio/dio.dart';

import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';

class MarkAllNotificationsReadApi {
  final Dio dio = Dio();

  Future<void> markAllNotificationsRead() async {
    final token = await TokenStorage.getToken();

    await dio.patch(
      "${ApiUrl.baseUrl}/notifications/read-all",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );
  }
}
