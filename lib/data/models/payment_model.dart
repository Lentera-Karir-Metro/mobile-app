/// Model untuk checkout response dari backend
/// Backend returns: {
///   "message": "...",
///   "order_id": "LENTERA-...",
///   "original_price": 0,
///   "discount_amount": 0,
///   "final_price": 0,
///   "transaction": { "token": "...", "redirect_url": "..." },
///   "enrollment_id": "..."
/// }
class PaymentModel {
  final String orderId;
  final String? enrollmentId;
  final double originalPrice;
  final double discountAmount;
  final double finalPrice;
  final String? snapToken;
  final String? redirectUrl;
  final String status;
  final String? message;

  PaymentModel({
    required this.orderId,
    this.enrollmentId,
    this.originalPrice = 0,
    this.discountAmount = 0,
    this.finalPrice = 0,
    this.snapToken,
    this.redirectUrl,
    this.status = 'pending',
    this.message,
  });

  /// Parse from checkout response (POST /payments/checkout)
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    // Handle nested transaction object
    final transaction = json['transaction'] as Map<String, dynamic>?;
    
    return PaymentModel(
      orderId: json['order_id']?.toString() ?? '',
      enrollmentId: json['enrollment_id']?.toString(),
      originalPrice: _parseDouble(json['original_price']),
      discountAmount: _parseDouble(json['discount_amount']),
      finalPrice: _parseDouble(json['final_price']),
      snapToken: transaction?['token'] ?? json['token'] ?? json['snap_token'],
      redirectUrl: transaction?['redirect_url'] ?? json['redirect_url'],
      status: json['status'] ?? 'pending',
      message: json['message'],
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) {
      if (value.isNaN || value.isInfinite) return 0.0;
      return value;
    }
    if (value is int) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value) ?? 0.0;
      if (parsed.isNaN || parsed.isInfinite) return 0.0;
      return parsed;
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'enrollment_id': enrollmentId,
      'original_price': originalPrice,
      'discount_amount': discountAmount,
      'final_price': finalPrice,
      'snap_token': snapToken,
      'redirect_url': redirectUrl,
      'status': status,
    };
  }

  bool get isPending => status == 'pending';
  bool get isPaid => status == 'paid' || status == 'success';
  bool get isExpired => status == 'expired';
  bool get isCancelled => status == 'cancelled';
  bool get isFailed => status == 'failed';

  // Getter alias for screen compatibility
  String? get transactionToken => snapToken;

  String get statusText {
    switch (status) {
      case 'pending':
        return 'Menunggu Pembayaran';
      case 'paid':
      case 'success':
        return 'Pembayaran Berhasil';
      case 'expired':
        return 'Kedaluwarsa';
      case 'cancelled':
        return 'Dibatalkan';
      case 'failed':
        return 'Gagal';
      default:
        return status;
    }
  }
}

/// Model untuk status check response
class PaymentStatusModel {
  final String orderId;
  final String status;
  final String? paymentType;
  final String? transactionTime;
  final double? grossAmount;
  final String? message;

  PaymentStatusModel({
    required this.orderId,
    required this.status,
    this.paymentType,
    this.transactionTime,
    this.grossAmount,
    this.message,
  });

  factory PaymentStatusModel.fromJson(Map<String, dynamic> json) {
    return PaymentStatusModel(
      orderId: json['order_id']?.toString() ?? '',
      status: json['status'] ?? 'pending',
      paymentType: json['payment_type'],
      transactionTime: json['transaction_time'],
      grossAmount: PaymentModel._parseDouble(json['gross_amount']),
      message: json['message'],
    );
  }

  bool get isSuccess => status == 'success' || status == 'settlement' || status == 'capture';
  bool get isPending => status == 'pending';
  bool get isFailed => status == 'deny' || status == 'cancel' || status == 'expire' || status == 'failure';
}
