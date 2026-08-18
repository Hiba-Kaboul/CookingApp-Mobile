import 'package:dio/dio.dart';

import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';

class DeleteNotificationApi {
  final Dio dio = Dio();

  Future<void> deleteNotification(String id) async {
    final token = await TokenStorage.getToken();

    try {
      await dio.delete(
        "${ApiUrl.baseUrl}/notifications/$id",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
          validateStatus: (status) =>
              status != null && status >= 200 && status < 300,
        ),
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "تعذر حذف الإشعار",
      );
    }
  }
}
