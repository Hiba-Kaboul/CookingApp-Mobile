class SharePostResponse {
  final int status;
  final String message;
  final SharePostData data;

  SharePostResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SharePostResponse.fromMap(Map<String, dynamic> map) {
    return SharePostResponse(
      status: map['status'] ?? 0,
      message: map['message'] ?? '',
      data: SharePostData.fromMap(
        Map<String, dynamic>.from(map['data'] as Map? ?? {}),
      ),
    );
  }
}

class SharePostData {
  final String deepLink;
  final String whatsappUrl;
  final String telegramUrl;
  final int sharesCount;

  SharePostData({
    required this.deepLink,
    required this.whatsappUrl,
    required this.telegramUrl,
    required this.sharesCount,
  });

  factory SharePostData.fromMap(Map<String, dynamic> map) {
    return SharePostData(
      deepLink: map['deep_link'] ?? '',
      whatsappUrl: map['whatsapp_url'] ?? '',
      telegramUrl: map['telegram_url'] ?? '',
      sharesCount: map['shares_count'] ?? 0,
    );
  }

  SharePostData copyWith({
    String? shareUrl,
    String? whatsappUrl,
    String? telegramUrl,
    int? sharesCount,
  }) {
    return SharePostData(
      deepLink: shareUrl ?? this.deepLink,
      whatsappUrl: whatsappUrl ?? this.whatsappUrl,
      telegramUrl: telegramUrl ?? this.telegramUrl,
      sharesCount: sharesCount ?? this.sharesCount,
    );
  }
}