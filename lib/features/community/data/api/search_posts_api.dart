import 'package:dio/dio.dart';
import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../model/search_post_model.dart';

class SearchPostsApi {
  final Dio dio = Dio();

  Future<PostsSearchResponse> searchPosts(String query) async {
    final token = await TokenStorage.getToken();

    final response = await dio.get(
      "${ApiUrl.baseUrl}/posts",
      queryParameters: {
        "search": query,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return PostsSearchResponse.fromMap(response.data);
  }
}