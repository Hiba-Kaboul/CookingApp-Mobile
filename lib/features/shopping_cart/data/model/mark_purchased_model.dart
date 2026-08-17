// data/model/mark_purchased_model.dart
class MarkPurchasedResponse {
  final int status;
  final String message;
  final int updatedCount;

  MarkPurchasedResponse({
    required this.status,
    required this.message,
    required this.updatedCount,
  });

  factory MarkPurchasedResponse.fromMap(Map<String, dynamic> map) {
    return MarkPurchasedResponse(
      status: map['status'] ?? 0,
      message: map['message'] ?? '',
      updatedCount: map['data']?['updated'] ?? 0,
    );
  }
}