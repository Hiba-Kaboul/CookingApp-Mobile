import 'package:dio/dio.dart';

import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../model/save_unsave_posts.dart';

class SaveUnsavePostsApi {
  final Dio dio = Dio();

  Future<SaveUnsavePosts> save_unsave_PostApi(int id) async {
    final token = await TokenStorage.getToken();

    final response = await dio.post(
      "${ApiUrl.baseUrl}/posts/$id/save",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
    print(id);
  return SaveUnsavePosts.fromMap(response.data);
  }
}
