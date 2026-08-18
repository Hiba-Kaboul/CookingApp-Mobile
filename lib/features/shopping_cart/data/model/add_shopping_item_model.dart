class AddShoppingItemResponse {
  final int status;
  final String message;
  final ShoppingItem data;

  AddShoppingItemResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AddShoppingItemResponse.fromMap(Map<String, dynamic> map) {
    return AddShoppingItemResponse(
      status: map["status"],
      message: map["message"],
      data: ShoppingItem.fromMap(map["data"]),
    );
  }
}

class ShoppingItem {
  final int id;
  final int ingredientId;
  final String name;
  final bool isPurchased;
  final String createdAt;

  ShoppingItem({
    required this.id,
    required this.ingredientId,
    required this.name,
    required this.isPurchased,
    required this.createdAt,
  });

  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      id: map["id"],
      ingredientId: map["ingredient_id"],
      name: map["name"],
      isPurchased: map["is_purchased"],
      createdAt: map["created_at"],
    );
  }
}