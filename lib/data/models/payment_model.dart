class PaymentModel {
  final int id;
  final double amount;
  final String status; // 'pending', 'approved', 'rejected'
  final String payableType; // 'tour_bookings'
  final int payableId;
  final String? receiptImage;
  final String? createdAt;

  PaymentModel({
    required this.id,
    required this.amount,
    required this.status,
    required this.payableType,
    required this.payableId,
    this.receiptImage,
    this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      payableType: json['payable_type'] ?? '',
      payableId: json['payable_id'] ?? 0,
      receiptImage: json['receipt_image'],
      createdAt: json['created_at'],
    );
  }
}
