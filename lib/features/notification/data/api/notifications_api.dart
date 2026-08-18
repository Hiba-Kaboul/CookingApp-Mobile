import 'package:dio/dio.dart';

import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../models/notification_model.dart';

class NotificationsApi {
  final Dio dio = Dio();

  Future<NotificationsResponse> getNotifications() async {
    final token = await TokenStorage.getToken();

    final response = await dio.get(
      "${ApiUrl.baseUrl}/notifications",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );

    return NotificationsResponse.fromJson(response.data);
  }
}
