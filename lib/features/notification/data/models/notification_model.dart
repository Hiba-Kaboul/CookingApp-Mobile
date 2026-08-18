import 'dart:convert';

class NotificationsResponse {
  final List<NotificationModel> data;
  final int? unreadCount;

  NotificationsResponse({required this.data, this.unreadCount});

  factory NotificationsResponse.fromJson(dynamic json) {
    if (json is List) {
      final items = json
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return NotificationsResponse(
        data: items,
        unreadCount: items.where((item) => !item.isRead).length,
      );
    }

    final map = json as Map<String, dynamic>;
    final raw = map['data'] is List
        ? map['data']
        : map['notifications'] is List
            ? map['notifications']
            : map['data'] is Map<String, dynamic> &&
                    map['data']['data'] is List
                ? map['data']['data']
                : null;

    final items = raw is List
        ? raw
            .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
            .toList()
        : <NotificationModel>[];

    final unreadFromApi = map['unread_count'] ??
        map['unreadCount'] ??
        map['meta']?['unread_count'];

    int? unreadCount;
    if (unreadFromApi is int) {
      unreadCount = unreadFromApi;
    } else if (unreadFromApi != null) {
      unreadCount = int.tryParse(unreadFromApi.toString());
    }
    unreadCount ??= items.where((item) => !item.isRead).length;

    return NotificationsResponse(data: items, unreadCount: unreadCount);
  }
}

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final String? readAt;
  final String createdAt;
  final int? postId;
  final int? recipeId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    this.readAt,
    required this.createdAt,
    this.postId,
    this.recipeId,
  });

  bool get isLike => type.toLowerCase().contains('like');
  bool get isComment => type.toLowerCase().contains('comment');
  bool get isApproved {
    final typeLower = type.toLowerCase();
    return typeLower.contains('approv') ||
        typeLower.contains('accept') ||
        typeLower.contains('قبول');
  }

  bool get isRejected {
    final typeLower = type.toLowerCase();
    return typeLower.contains('reject') ||
        typeLower.contains('declin') ||
        typeLower.contains('refus') ||
        typeLower.contains('رفض');
  }

  bool get isRecipe {
    final typeLower = type.toLowerCase();
    if (isApproved || isRejected || isLike || isComment) return false;
    return typeLower.contains('recipe') ||
        typeLower.contains('published') ||
        typeLower.contains('new_recipe');
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> nested = {};
    if (json['data'] is Map<String, dynamic>) {
      nested = json['data'] as Map<String, dynamic>;
    } else if (json['data'] is String) {
      try {
        final decoded = jsonDecode(json['data'] as String);
        if (decoded is Map<String, dynamic>) {
          nested = decoded;
        }
      } catch (_) {}
    }

    final readAtRaw = json['read_at']?.toString();
    final readAt =
        (readAtRaw == null || readAtRaw.isEmpty || readAtRaw == 'null')
            ? null
            : readAtRaw;

    final isUnreadFlag = json['is_unread'] == true ||
        json['unread'] == true ||
        json['status']?.toString() == 'unread';

    final isReadFlag = json['is_read'] == true ||
        json['is_read'] == 1 ||
        json['is_read'] == '1' ||
        json['read'] == true;

    final isRead = isUnreadFlag
        ? false
        : isReadFlag || (readAt != null && readAt.contains(RegExp(r'\d')));

    final type = (json['type'] ?? nested['type'] ?? '').toString();
    final typeLower = type.toLowerCase();

    String title =
        json['title']?.toString() ?? nested['title']?.toString() ?? '';
    String body = json['body']?.toString() ??
        json['message']?.toString() ??
        nested['body']?.toString() ??
        nested['message']?.toString() ??
        '';

    if (title.isEmpty) {
      if (typeLower.contains('like')) {
        title = 'إعجاب جديد';
      } else if (typeLower.contains('comment')) {
        title = 'تعليق جديد';
      } else if (typeLower.contains('reject') ||
          typeLower.contains('declin') ||
          typeLower.contains('رفض')) {
        title = 'تم رفض منشورك';
      } else if (typeLower.contains('approv') ||
          typeLower.contains('accept') ||
          typeLower.contains('قبول')) {
        title = 'تم قبول منشورك';
      } else if (typeLower.contains('recipe') ||
          typeLower.contains('published')) {
        title = 'وصفة جديدة';
      }
    }

    if (body.isEmpty) {
      if (typeLower.contains('like')) {
        body = 'شخص أعجب بمنشورك';
      } else if (typeLower.contains('comment')) {
        body = 'شخص علّق على منشورك';
      } else if (typeLower.contains('reject') ||
          typeLower.contains('declin') ||
          typeLower.contains('رفض')) {
        body = 'الأدمن رفض منشورك';
      } else if (typeLower.contains('approv') ||
          typeLower.contains('accept') ||
          typeLower.contains('قبول')) {
        body = 'الأدمن قبل منشورك وصار ظاهر بالمجتمع';
      } else if (typeLower.contains('recipe') ||
          typeLower.contains('published')) {
        body = 'تم نشر وصفة جديدة';
      }
    }

    return NotificationModel(
      id: _parseId(json['id'] ?? json['uuid'] ?? nested['id']),
      title: title,
      body: body,
      type: type,
      isRead: isRead,
      readAt: readAt,
      createdAt: json['created_at']?.toString() ??
          nested['created_at']?.toString() ??
          '',
      postId: _parseOptionalInt(
        nested['post_id'] ??
            json['post_id'] ??
            nested['postId'] ??
            ((typeLower.contains('like') ||
                    typeLower.contains('comment') ||
                    typeLower.contains('post') ||
                    typeLower.contains('approv') ||
                    typeLower.contains('reject') ||
                    typeLower.contains('accept'))
                ? nested['id']
                : null),
      ),
      recipeId: _parseOptionalInt(
        nested['recipe_id'] ??
            json['recipe_id'] ??
            nested['recipeId'] ??
            ((typeLower.contains('recipe') ||
                    typeLower.contains('published'))
                ? nested['id']
                : null),
      ),
    );
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    bool? isRead,
    String? readAt,
    String? createdAt,
    int? postId,
    int? recipeId,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
      postId: postId ?? this.postId,
      recipeId: recipeId ?? this.recipeId,
    );
  }

  static String _parseId(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static int? _parseOptionalInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
