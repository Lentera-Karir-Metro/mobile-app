import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/primary_button.dart';
import 'package:lentera_karir/providers/payment_provider.dart';

/// Screen pending pembayaran
class PaymentPendingScreen extends StatefulWidget {
  final String orderId;
  final String? courseId;

  const PaymentPendingScreen({
    super.key,
    required this.orderId,
    this.courseId,
  });

  @override
  State<PaymentPendingScreen> createState() => _PaymentPendingScreenState();
}

class _PaymentPendingScreenState extends State<PaymentPendingScreen> {
  int _countdown = 10;
  Timer? _timer;
  bool _isCheckingStatus = false;

  @override
  void initState() {
    super.initState();
    // Defer network/state updates until after first frame to avoid
    // calling notifyListeners() during widget build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPaymentStatus();
    });

    // Start countdown immediately (safe) but ensure timer callbacks
    // check `mounted` before interacting with context.
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _checkPaymentStatus() async {
    setState(() {
      _isCheckingStatus = true;
    });

    try {
      final paymentProvider = context.read<PaymentProvider>();
      await paymentProvider.checkPaymentStatus(widget.orderId);

      if (paymentProvider.status.toString() == 'PaymentStatus.success' && mounted) {
        // Payment confirmed! Navigate to success
        context.go('/payment/success', extra: {
          'orderId': widget.orderId,
          'courseId': widget.courseId,
        });
      }
    } catch (e) {
      // Ignore errors, just show pending state
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingStatus = false;
        });
      }
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      // Safe to call setState while mounted and outside build phase
      setState(() {
        _countdown--;
      });

      if (_countdown <= 0) {
        timer.cancel();
        if (mounted) {
          _navigateToDashboard();
        }
      }
    });
  }

  void _navigateToDashboard() {
    context.go('/home');
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
              // Pending Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.schedule,
                  size: 80,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                'Pembayaran Tertunda',
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                'Pembayaran Anda sedang diproses. '
                'Kami akan memberitahu Anda setelah pembayaran dikonfirmasi.',
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
              const SizedBox(height: 24),

              // Check status button
              if (_isCheckingStatus)
                const CircularProgressIndicator()
              else
                TextButton.icon(
                  onPressed: _checkPaymentStatus,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Cek Status Pembayaran'),
                ),
              
              const SizedBox(height: 16),

              // Countdown text
              Text(
                'Menuju dashboard dalam $_countdown detik...',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Button
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Ke Dashboard',
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
