class DeleteRecipeComment {
  final String message;

  DeleteRecipeComment({required this.message});

  factory DeleteRecipeComment.fromMap(Map<String, dynamic> map) {
    return DeleteRecipeComment(
      message: map['message'] ?? 'تم حذف التعليق بنجاح',
    );
  }
}