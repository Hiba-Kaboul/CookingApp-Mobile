import 'package:dio/dio.dart';
import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../model/delete_comment_model.dart';

class DeleteCommentApi {
  final Dio dio = Dio();

  Future<DeleteCommentModel> deleteComment(int commentId) async {
    final token = await TokenStorage.getToken();

    try {
      final response = await dio.delete(
        "${ApiUrl.baseUrl}/comments/$commentId",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      return DeleteCommentModel.fromJson(response.data);
    } on DioException catch (e) {
      // ✅ نلتقط رسالة الـ unauthorized من الباك اند إذا موجودة
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        final serverMessage = e.response?.data is Map
            ? e.response?.data['message']
            : null;
        throw serverMessage ?? "غير مصرح لك بحذف هذا التعليق";
      }
      throw e.response?.data?['message'] ?? "حدث خطأ أثناء الحذف";
    }
  }
}