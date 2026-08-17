class ShareRecipeResponse {
  final int status;
  final String message;
  final ShareRecipeData data;

  ShareRecipeResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ShareRecipeResponse.fromMap(Map<String, dynamic> map) {
    return ShareRecipeResponse(
      status: map['status'] ?? 0,
      message: map['message'] ?? '',
      data: ShareRecipeData.fromMap(
        Map<String, dynamic>.from(map['data'] as Map? ?? {}),
      ),
    );
  }
}

class ShareRecipeData {
  final String shareUrl;
  final String whatsappUrl;
  final String telegramUrl;
  final int sharesCount;

  ShareRecipeData({
    required this.shareUrl,
    required this.whatsappUrl,
    required this.telegramUrl,
    required this.sharesCount,
  });

  factory ShareRecipeData.fromMap(Map<String, dynamic> map) {
    return ShareRecipeData(
      shareUrl: map['share_url'] ?? '',
      whatsappUrl: map['whatsapp_url'] ?? '',
      telegramUrl: map['telegram_url'] ?? '',
      sharesCount: map['shares_count'] ?? 0,
    );
  }
}