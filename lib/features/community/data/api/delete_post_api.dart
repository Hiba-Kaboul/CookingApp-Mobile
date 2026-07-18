import 'package:dio/dio.dart';

import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';

class DeletePostApi {
  final Dio dio = Dio();

  Future<bool> deletePostApi(int id) async {
    final token = await TokenStorage.getToken();

    final response = await dio.delete(
      "${ApiUrl.baseUrl}/posts/$id",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
    if (response.statusCode == 200) {
      print("Deleted Booking successfully!!");
      return true;
    } else {
      throw Exception(
          "Failed to preview reservation. Status code: ${response.statusCode}");
    }
  }
}
