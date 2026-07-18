import 'package:dio/dio.dart';

import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../model/like_unlike_posts.dart';

class LikeUnlikePostsApi {
  final Dio dio = Dio();

  Future<LikeUnlikePosts> like_unlike_PostApi(int id) async {
    final token = await TokenStorage.getToken();

    final response = await dio.post(
      "${ApiUrl.baseUrl}/posts/$id/like",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
  return LikeUnlikePosts.fromMap(response.data);
  }
}
