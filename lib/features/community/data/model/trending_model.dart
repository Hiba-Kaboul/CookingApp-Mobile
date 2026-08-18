class TrendingResponse {
  final List<TrendingItem> data;

  TrendingResponse({required this.data});

  factory TrendingResponse.fromMap(dynamic json) {
    if (json is List) {
      return TrendingResponse(
        data: json
            .map((e) => TrendingItem.fromMap(e as Map<String, dynamic>))
            .toList(),
      );
    }

    final map = json as Map<String, dynamic>;
    final raw = map['data'];

    if (raw is List) {
      return TrendingResponse(
        data: raw
            .map((e) => TrendingItem.fromMap(e as Map<String, dynamic>))
            .toList(),
      );
    }

    if (raw is Map<String, dynamic>) {
      final recipes = raw['recipes'] as List? ?? [];
      final posts = raw['posts'] as List? ?? [];
      return TrendingResponse(
        data: [
          ...recipes.map((e) => TrendingItem.fromMap(
                e as Map<String, dynamic>,
                fallbackType: 'recipe',
              )),
          ...posts.map((e) => TrendingItem.fromMap(
                e as Map<String, dynamic>,
                fallbackType: 'post',
              )),
        ],
      );
    }

    final recipes = map['recipes'] as List? ?? [];
    final posts = map['posts'] as List? ?? [];
    if (recipes.isNotEmpty || posts.isNotEmpty) {
      return TrendingResponse(
        data: [
          ...recipes.map((e) => TrendingItem.fromMap(
                e as Map<String, dynamic>,
                fallbackType: 'recipe',
              )),
          ...posts.map((e) => TrendingItem.fromMap(
                e as Map<String, dynamic>,
                fallbackType: 'post',
              )),
        ],
      );
    }

    return TrendingResponse(data: []);
  }
}

class TrendingItem {
  final int id;
  final String type;
  final String title;
  final String imageUrl;
  final num rating;
  final int durationMinutes;

  TrendingItem({
    required this.id,
    required this.type,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.durationMinutes,
  });

  factory TrendingItem.fromMap(
    Map<String, dynamic> map, {
    String fallbackType = '',
  }) {
    final type = (map['type'] ?? fallbackType).toString().toLowerCase();
    final title = map['name']?.toString() ??
        map['title']?.toString() ??
        '';

    String imageUrl = '';
    final media = map['media'];
    if (media is List && media.isNotEmpty) {
      final first = media.first;
      if (first is Map) {
        imageUrl = first['url']?.toString() ?? '';
      }
    } else if (map['image'] != null) {
      imageUrl = map['image'].toString();
    } else if (map['cover'] != null) {
      imageUrl = map['cover'].toString();
    }

    final rating = map['avg_rating'] ?? map['rating'] ?? 0;
    final prepTime = map['prep_time'] ?? 0;
    final cookTime = map['cook_time'] ?? 0;
    final duration = map['duration'] ??
        map['time'] ??
        ((prepTime is num ? prepTime : 0) + (cookTime is num ? cookTime : 0));

    return TrendingItem(
      id: map['id'] is int
          ? map['id'] as int
          : int.tryParse('${map['id']}') ?? 0,
      type: type,
      title: title,
      imageUrl: imageUrl,
      rating: rating is num ? rating : num.tryParse('$rating') ?? 0,
      durationMinutes: duration is int
          ? duration
          : int.tryParse('$duration') ?? 0,
    );
  }
}
