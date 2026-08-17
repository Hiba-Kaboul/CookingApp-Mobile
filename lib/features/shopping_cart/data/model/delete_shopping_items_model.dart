// data/model/delete_shopping_items_model.dart
class DeleteShoppingItemsResponse {
  final int status;
  final String message;

  DeleteShoppingItemsResponse({
    required this.status,
    required this.message,
  });

  factory DeleteShoppingItemsResponse.fromMap(Map<String, dynamic> map) {
    return DeleteShoppingItemsResponse(
      status: map['status'] ?? 0,
      message: map['message'] ?? '',
    );
  }
}