import 'package:lentera_karir/data/api/api_service.dart';
import 'package:lentera_karir/data/api/endpoints.dart';

class PaymentService {
  final ApiService _apiService;

  PaymentService(this._apiService);

  // Create payment checkout session (Midtrans Snap)
  // Backend expects: { course_id: string }
  Future<Map<String, dynamic>> createPayment({
    required String courseId,
  }) async {
    return await _apiService.post(
      ApiEndpoints.createPayment,
      body: {
        'course_id': courseId,
      },
    );
  }

  // Create payment for course (alias for createPayment)
  Future<Map<String, dynamic>> createCoursePayment(String courseId) async {
    return await createPayment(courseId: courseId);
  }

  // Get payment status by order ID
  Future<Map<String, dynamic>> getPaymentStatus(String orderId) async {
    return await _apiService.get(ApiEndpoints.paymentStatus(orderId));
  }

  // Sync all pending payments for current user
  Future<Map<String, dynamic>> syncPendingPayments() async {
    return await _apiService.post(
      ApiEndpoints.syncPayments,
      body: {},
    );
  }
}
