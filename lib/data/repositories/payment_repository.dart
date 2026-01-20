import 'package:lentera_karir/data/models/payment_model.dart';
import 'package:lentera_karir/data/services/payment_service.dart';

abstract class PaymentRepository {
  Future<PaymentModel?> createCoursePayment(String courseId);
  Future<PaymentModel?> getPaymentStatus(String orderId);
  Future<bool> syncPendingPayments();
}

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentService _paymentService;

  PaymentRepositoryImpl(this._paymentService);

  @override
  Future<PaymentModel?> createCoursePayment(String courseId) async {
    try {
      final response = await _paymentService.createCoursePayment(courseId);
      // Backend returns: { success: true, transaction: { token, redirect_url, order_id } }
      if (response['success'] == true) {
        final transactionData = response['transaction'] ?? response['data'];
        if (transactionData != null) {
          return PaymentModel.fromJson(transactionData);
        }
      }
    } catch (e) {
      print('Error creating course payment: $e');
    }
    return null;
  }

  @override
  Future<PaymentModel?> getPaymentStatus(String orderId) async {
    try {
      final response = await _paymentService.getPaymentStatus(orderId);
      if (response['success'] == true && response['data'] != null) {
        return PaymentModel.fromJson(response['data']);
      }
    } catch (e) {
      print('Error getting payment status: $e');
    }
    return null;
  }

  @override
  Future<bool> syncPendingPayments() async {
    try {
      final response = await _paymentService.syncPendingPayments();
      return response['success'] == true;
    } catch (e) {
      print('Error syncing pending payments: $e');
      return false;
    }
  }
}
