import 'package:flutter/material.dart';
import 'package:lentera_karir/data/models/payment_model.dart';
import 'package:lentera_karir/data/repositories/payment_repository.dart';

enum PaymentStatus {
  initial,
  loading,
  created,
  checking,
  success,
  failed,
  error,
}

class PaymentProvider extends ChangeNotifier {
  final PaymentRepository _paymentRepository;

  PaymentProvider(this._paymentRepository);

  PaymentStatus _status = PaymentStatus.initial;
  PaymentModel? _currentPayment;
  String? _errorMessage;

  PaymentStatus get status => _status;
  PaymentModel? get currentPayment => _currentPayment;
  String? get errorMessage => _errorMessage;
  bool get isLoading =>
      _status == PaymentStatus.loading || _status == PaymentStatus.checking;

  /// Create payment for a course (main method)
  /// courseId should be a String like "CR-xxxxxx"
  Future<PaymentModel?> createCoursePayment(String courseId) async {
    _status = PaymentStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentPayment = await _paymentRepository.createCoursePayment(courseId);
      if (_currentPayment != null) {
        _status = PaymentStatus.created;
      } else {
        _errorMessage = 'Gagal membuat pembayaran';
        _status = PaymentStatus.error;
      }
    } catch (e) {
      _errorMessage = 'Gagal membuat pembayaran: $e';
      _status = PaymentStatus.error;
    }

    notifyListeners();
    return _currentPayment;
  }

  /// Alias for createCoursePayment for screen compatibility
  Future<PaymentModel?> createPayment(String courseId) async {
    return createCoursePayment(courseId);
  }

  Future<void> checkPaymentStatus(String orderId) async {
    _status = PaymentStatus.checking;
    notifyListeners();

    try {
      final payment = await _paymentRepository.getPaymentStatus(orderId);
      if (payment != null) {
        _currentPayment = payment;
        if (payment.isPaid) {
          _status = PaymentStatus.success;
        } else if (payment.isFailed ||
            payment.isExpired ||
            payment.isCancelled) {
          _status = PaymentStatus.failed;
        } else {
          _status = PaymentStatus.created;
        }
      }
    } catch (e) {
      _errorMessage = 'Gagal mengecek status pembayaran: $e';
      _status = PaymentStatus.error;
    }

    notifyListeners();
  }

  Future<bool> syncPendingPayments() async {
    try {
      return await _paymentRepository.syncPendingPayments();
    } catch (e) {
      return false;
    }
  }

  void clearCurrentPayment() {
    _currentPayment = null;
    _status = PaymentStatus.initial;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
