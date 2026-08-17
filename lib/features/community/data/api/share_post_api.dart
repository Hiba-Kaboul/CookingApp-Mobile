import 'package:dio/dio.dart';
import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../model/share_post_model.dart';

class SharePostApi {
  final Dio dio = Dio();

  Future<SharePostResponse> sharePost({
    required int postId,
    required String platform, // whatsapp | telegram | copy_link | other
  }) async {
    final token = await TokenStorage.getToken();

    final response = await dio.post(
      "${ApiUrl.baseUrl}/posts/$postId/share",
      data: {
        "platform": platform,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );

    return SharePostResponse.fromMap(response.data);
  }
}