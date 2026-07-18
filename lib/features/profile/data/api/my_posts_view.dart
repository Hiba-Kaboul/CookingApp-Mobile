import 'package:dio/dio.dart';
import '../../../../../core/constants/api_url.dart';
import '../../../../../core/utils/token_storage.dart';
import '../../../community/data/model/users_model.dart';

class MyPostsViewApi {
  final Dio dio = Dio();

  Future<UsersPostsModel> getMyPosts(int page) async {
    final token = await TokenStorage.getToken();

    final response = await dio.get(
      "${ApiUrl.baseUrl}/posts/my/list",
      queryParameters: {
        "status": "approved",
        "page": page,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return UsersPostsModel.fromJson(response.data);
  }
}
