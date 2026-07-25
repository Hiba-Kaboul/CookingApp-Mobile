import 'package:dio/dio.dart';
import 'package:project2/features/community/data/model/comment_model.dart';

import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';

class CommentApi {
  final Dio dio = Dio();

  Future<CommentModel> commentOnPost(int id, String body) async {
    final token = await TokenStorage.getToken();

    final response = await dio.post(
      "${ApiUrl.baseUrl}/posts/$id/comments",
      data: {
        "body": body,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
    return CommentModel.fromMap(response.data);
  }
}