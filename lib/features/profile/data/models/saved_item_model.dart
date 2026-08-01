class SavedItemsResponse {
  final List<SavedItem> data;
  final SavedMeta meta;

  SavedItemsResponse({required this.data, required this.meta});

  factory SavedItemsResponse.fromMap(Map<String, dynamic> map) {
    return SavedItemsResponse(
      data: List<SavedItem>.from(
        (map['data'] as List).map((e) => SavedItem.fromMap(e)),
      ),
      meta: SavedMeta.fromMap(map['meta']),
    );
  }
}

class SavedItem {
  final String type; // "recipe" أو "post"
  final int id;
  final String name;
  final String image;

  SavedItem({
    required this.type,
    required this.id,
    required this.name,
    required this.image,
  });

  factory SavedItem.fromMap(Map<String, dynamic> map) {
    return SavedItem(
      type: map['type'] ?? '',
      id: map['id'],
      name: map['name'] ?? '',
      image: map['image'] ?? '',
    );
  }

  bool get isRecipe => type == 'recipe';
  bool get isPost => type == 'post';

  /// فحص بسيط إذا كانت الوسيلة فيديو (بناءً على امتداد الرابط)
  bool get isVideo =>
      image.endsWith('.mp4') || image.contains('/video/upload/');
}

class SavedMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  SavedMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory SavedMeta.fromMap(Map<String, dynamic> map) {
    return SavedMeta(
      currentPage: map['current_page'] ?? 1,
      lastPage: map['last_page'] ?? 1,
      perPage: map['per_page'] ?? 20,
      total: map['total'] ?? 0,
    );
  }
}