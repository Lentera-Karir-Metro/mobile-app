import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/primary_button.dart';

/// Screen sukses pembayaran
class PaymentSuccessScreen extends StatefulWidget {
  final String orderId;
  final String? courseId;

  const PaymentSuccessScreen({
    super.key,
    required this.orderId,
    this.courseId,
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  int _countdown = 5;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
      });
      if (_countdown <= 0) {
        timer.cancel();
        _navigateToDashboard();
      }
    });
  }

  void _navigateToDashboard() {
    if (widget.courseId != null) {
      // Navigate to the course learning page
      context.go('/kelas/mulai/${widget.courseId}');
    } else {
      // Navigate to dashboard
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.successGreen.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 80,
                  color: AppColors.successGreen,
                ),
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                'Pembayaran Berhasil!',
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                'Terima kasih! Pembayaran Anda telah berhasil diproses. '
                'Anda sekarang dapat mengakses kelas.',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Order ID
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Order ID',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.orderId,
                      style: AppTextStyles.subtitle1.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Countdown text
              Text(
                'Menuju halaman kelas dalam $_countdown detik...',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Button
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: widget.courseId != null ? 'Mulai Belajar' : 'Ke Dashboard',
                  onPressed: () {
                    _timer?.cancel();
                    _navigateToDashboard();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
