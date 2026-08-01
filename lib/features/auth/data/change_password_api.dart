import 'package:dio/dio.dart';

import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import 'models/change_password_model.dart';

class ChangePasswordApi {
  final Dio dio = Dio();

  Future<ChangePassword> changePasswordApi({
    required String password,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    final token = await TokenStorage.getToken();

    final response = await dio.post(
      "${ApiUrl.baseUrl}/auth/change-password",
      data: {
        "password": password,
        "newPassword": newPassword,
        "newPassword_confirmation": newPasswordConfirmation,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return ChangePassword.fromMap(response.data);
  }
}