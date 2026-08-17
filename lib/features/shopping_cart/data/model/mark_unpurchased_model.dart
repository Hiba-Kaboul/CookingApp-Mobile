// data/model/mark_unpurchased_model.dart
class MarkUnpurchasedResponse {
  final int status;
  final String message;
  final int updatedCount;

  MarkUnpurchasedResponse({
    required this.status,
    required this.message,
    required this.updatedCount,
  });

  factory MarkUnpurchasedResponse.fromMap(Map<String, dynamic> map) {
    return MarkUnpurchasedResponse(
      status: map['status'] ?? 0,
      message: map['message'] ?? '',
      updatedCount: map['data']?['updated'] ?? 0,
    );
  }
}