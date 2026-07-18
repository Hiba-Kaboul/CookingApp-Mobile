import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/api_url.dart';
import '../../../../../core/utils/token_storage.dart';
import '../model/users_model.dart';


class UsersPostsApi {
  final Dio dio = Dio();

  Future<UsersPostsModel> getUsersPosts( int page) async {
    final token = await TokenStorage.getToken();

    final response = await dio.get(
      "${ApiUrl.baseUrl}/posts",
      queryParameters: {"page":page},
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return UsersPostsModel.fromJson(response.data);
  }
}