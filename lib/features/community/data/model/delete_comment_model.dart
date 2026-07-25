class DeleteCommentModel {
  final int status;
  final String message;

  DeleteCommentModel({
    required this.status,
    required this.message,
  });

  factory DeleteCommentModel.fromJson(Map<String, dynamic> json) {
    return DeleteCommentModel(
      status: json['status'] as int,
      message: json['message'] as String,
    );
  }
}