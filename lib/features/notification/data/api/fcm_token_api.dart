import 'package:dio/dio.dart';

import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';

class FcmTokenApi {
  final Dio dio = Dio();

  Future<void> updateFcmToken(String fcmToken) async {
    final token = await TokenStorage.getToken();

    await dio.post(
      "${ApiUrl.baseUrl}/notifications/fcm-token",
      data: {
        "fcm_token": fcmToken,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );
  }
}
