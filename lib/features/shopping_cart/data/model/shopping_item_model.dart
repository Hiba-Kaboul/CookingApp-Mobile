// data/model/shopping_item_model.dart
class ShoppingListResponse {
  final List<ShoppingItem> data;

  ShoppingListResponse({required this.data});

  factory ShoppingListResponse.fromMap(Map<String, dynamic> map) {
    return ShoppingListResponse(
      data: List<ShoppingItem>.from(
        (map['data'] as List).map((e) => ShoppingItem.fromMap(e)),
      ),
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
      id: map['id'] ?? 0,
      ingredientId: map['ingredient_id'] ?? 0,
      name: map['name'] ?? '',
      isPurchased: map['is_purchased'] ?? false,
      createdAt: map['created_at'] ?? '',
    );
  }

  // مفيد لما نعمل تحديث محلي بدون ما نعيد نداء كامل للـ API
  ShoppingItem copyWith({bool? isPurchased}) {
    return ShoppingItem(
      id: id,
      ingredientId: ingredientId,
      name: name,
      isPurchased: isPurchased ?? this.isPurchased,
      createdAt: createdAt,
    );
  }
}