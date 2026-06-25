import 'dart:io';

import 'package:dio/dio.dart';
import 'package:project2/core/constants/api_url.dart';
import 'package:project2/core/utils/token_storage.dart';

class EditProfileApi {
  final Dio dio = Dio();

  Future<String> updateProfile({
    required String name,
    required String bio,
    required String language,
    required String theme,
    File? image,
  }) async {
    final token = await TokenStorage.getToken();

    FormData formData = FormData.fromMap({
      "name": name,
      "bio": bio,
      "language": language,
      "theme": theme,
      if (image != null)
        "avatar": await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
    });

    final response = await dio.post(
      "${ApiUrl.baseUrl}/auth/profile/update",
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return response.data["message"];
  }
}