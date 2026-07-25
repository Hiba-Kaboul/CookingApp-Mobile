import 'package:dio/dio.dart';
import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../model/comments_list_model.dart';

class GetCommentsApi {
  final Dio dio = Dio();

  Future<CommentsListModel> getComments(int postId, {int page = 1}) async {
    final token = await TokenStorage.getToken();

    final response = await dio.get(
      "${ApiUrl.baseUrl}/posts/$postId/comments",
      queryParameters: {"page": page},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    return CommentsListModel.fromJson(response.data);
  }
}