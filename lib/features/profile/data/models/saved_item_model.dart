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
  final List<SavedMedia> media;

  SavedItem({
    required this.type,
    required this.id,
    required this.name,
    required this.media,
  });

  factory SavedItem.fromMap(Map<String, dynamic> map) {
    return SavedItem(
      type: map['type'] ?? '',
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      media: map['media'] == null
          ? []
          : List<SavedMedia>.from(
              (map['media'] as List).map((e) => SavedMedia.fromMap(e)),
            ),
    );
  }

  SavedItem copyWith({
    String? type,
    int? id,
    String? name,
    List<SavedMedia>? media,
  }) {
    return SavedItem(
      type: type ?? this.type,
      id: id ?? this.id,
      name: name ?? this.name,
      media: media ?? this.media,
    );
  }

  bool get isRecipe => type == 'recipe';
  bool get isPost => type == 'post';
  bool get hasMultipleMedia => media.length > 1;

  /// أول صورة إن وُجدت، وإلا أول عنصر (فيديو مثلاً)
  SavedMedia? get coverMedia {
    if (media.isEmpty) return null;

    final image = media.where((m) => m.isImage).toList();
    if (image.isNotEmpty) {
      image.sort((a, b) => a.order.compareTo(b.order));
      return image.first;
    }

    final sorted = List<SavedMedia>.from(media)
      ..sort((a, b) => a.order.compareTo(b.order));
    return sorted.first;
  }

  bool get isVideoCover => coverMedia?.isVideo ?? false;
}

class SavedMedia {
  final int id;
  final String type; // "image" أو "video"
  final String url;
  final int order;

  SavedMedia({
    required this.id,
    required this.type,
    required this.url,
    required this.order,
  });

  factory SavedMedia.fromMap(Map<String, dynamic> map) {
    return SavedMedia(
      id: map['id'] ?? 0,
      type: map['type'] ?? '',
      url: map['url'] ?? '',
      order: map['order'] ?? 0,
    );
  }

  SavedMedia copyWith({
    int? id,
    String? type,
    String? url,
    int? order,
  }) {
    return SavedMedia(
      id: id ?? this.id,
      type: type ?? this.type,
      url: url ?? this.url,
      order: order ?? this.order,
    );
  }

  bool get isImage => type == 'image';
  bool get isVideo =>
      type == 'video' || url.endsWith('.mp4') || url.contains('/video/upload/');
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
