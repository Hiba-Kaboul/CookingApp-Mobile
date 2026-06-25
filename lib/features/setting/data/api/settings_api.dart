import 'package:dio/dio.dart';
import 'package:project2/core/constants/api_url.dart';
import '../models/settings_model.dart';
import '../../../../core/utils/token_storage.dart';

class SettingsApi {
  final Dio dio = Dio();

  Future<ProfileResponseModel> getUserInfo() async {
    try {
      final token = await TokenStorage.getToken();

      print("TOKEN = $token");

      final response = await dio.get(
        "${ApiUrl.baseUrl}/auth/profile/show",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      print(response.data);

      return ProfileResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      print('STATUS CODE: ${e.response?.statusCode}');
      print('RESPONSE: ${e.response?.data}');
      rethrow;
    }
  }
}