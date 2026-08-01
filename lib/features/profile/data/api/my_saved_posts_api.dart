import 'package:dio/dio.dart';
import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../../../community/data/model/search_post_model.dart';


class SavedPostsApi {
  final Dio dio = Dio();

  Future<List<Post>> getSavedPosts({int page = 1}) async {
    final token = await TokenStorage.getToken();

    final response = await dio.get(
      "${ApiUrl.baseUrl}/saved",
      queryParameters: {
        "page": page,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    final List data = response.data['data'];
    return data.map((e) => Post.fromMap(e)).toList();
  }
}