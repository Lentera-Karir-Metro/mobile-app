import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';
import 'package:lentera_karir/widgets/universal/buttons/primary_button.dart';

/// Halaman Payment - menampilkan detail pembayaran dan countdown timer
/// Terintegrasi dengan Midtrans Payment Gateway
class PaymentScreen extends StatefulWidget {
  final String courseId;
  
  // Data yang akan diterima dari backend setelah create transaction
  final String orderId;
  final String totalAmount;
  final DateTime expiredAt;
  final String? transactionToken; // Token untuk Midtrans
  final String? redirectUrl; // URL Midtrans webview

  const PaymentScreen({
    super.key,
    required this.courseId,
    required this.orderId,
    required this.totalAmount,
    required this.expiredAt,
    this.transactionToken,
    this.redirectUrl,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Timer? _countdownTimer;
  Duration _remainingTime = Duration.zero;
  String? _selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _remainingTime = widget.expiredAt.difference(DateTime.now());
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime = widget.expiredAt.difference(DateTime.now());
        
        // Stop timer jika waktu habis
        if (_remainingTime.isNegative || _remainingTime.inSeconds <= 0) {
          timer.cancel();
          _remainingTime = Duration.zero;
          // TODO: Show dialog bahwa pembayaran expired
        }
      });
    });
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative || duration.inSeconds <= 0) {
      return "00:00:00";
    }
    
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    
    return "$hours:$minutes:$seconds";
  }

  void _handlePayment() {
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih metode pembayaran terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: Implement Midtrans integration
    // Option 1: WebView dengan redirectUrl
    // Option 2: Deep link ke app payment (Gopay, DANA, dll)
    
    // Untuk demo, show dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Proses Pembayaran'),
        content: Text('Membuka $_selectedPaymentMethod...\n\nDalam implementasi real, ini akan membuka Midtrans WebView atau deep link ke app payment.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Replace dengan data dari API
    final String courseTitle = "Bootcamp: Kick-start\nKarier Digital";
    final String releaseDate = "Released date March 2025";
    final String lastUpdate = "Last updated August 2025";

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Banner
                _buildHeader(courseTitle, releaseDate, lastUpdate),

                // Order Info Card
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: _buildOrderInfoCard(),
                ),

                // Payment Methods Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: _buildPaymentMethodsCard(),
                ),

                // Space untuk button
                const SizedBox(height: 100),
              ],
            ),
          ),

          // Back Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CustomBackButton(
                backgroundColor: AppColors.cardBackground,
                iconColor: AppColors.textPrimary,
              ),
            ),
          ),

          // Bottom Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomButton(),
          ),
        ],
      ),
    );
  }

  /// Header dengan banner sesuai design
  Widget _buildHeader(String title, String releaseDate, String lastUpdate) {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Stack(
        children: [
          // Background banner image
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Image.asset(
                'assets/header-banner/header_banner.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Content di bagian bawah banner
          Positioned(
            left: 20,
            right: 20,
            bottom: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Course Title
                Text(
                  title,
                  style: AppTextStyles.heading2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Released date row
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/kelas/globe.svg',
                      width: 18,
                      height: 18,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      releaseDate,
                      style: AppTextStyles.body2.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                
                // Last updated row
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/kelas/last_update.svg',
                      width: 18,
                      height: 18,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      lastUpdate,
                      style: AppTextStyles.body2.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Order Info Card dengan countdown timer sesuai design
  Widget _buildOrderInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Amount
          Text(
            widget.totalAmount,
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          
          // Order ID
          Text(
            'Order ID ${widget.orderId}',
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Countdown Timer Bar - sesuai design (abu-abu #D9D9D9)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Lakukan transaksi dalam ${_formatDuration(_remainingTime)}',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// Payment Methods Card sesuai design
  Widget _buildPaymentMethodsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'All payment methods',
            style: AppTextStyles.subtitle1.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          // E-Wallet Section
          Text(
            'E-Wallet',
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          _buildPaymentMethodItem(
            logoPath: 'assets/payment-gateway/gopay.svg',
            name: 'Gopay',
            value: 'gopay',
          ),
          const SizedBox(height: 10),
          _buildPaymentMethodItem(
            logoPath: 'assets/payment-gateway/dana.svg',
            name: 'DANA',
            value: 'dana',
          ),
          
          const SizedBox(height: 20),
          
          // Virtual Account Section
          Text(
            'Virtual Account',
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          _buildPaymentMethodItem(
            logoPath: 'assets/payment-gateway/mandiri.svg',
            name: 'Bank Mandiri',
            value: 'mandiri',
          ),
          const SizedBox(height: 10),
          _buildPaymentMethodItem(
            logoPath: 'assets/payment-gateway/bni.svg',
            name: 'Bank BNI',
            value: 'bni',
          ),
          const SizedBox(height: 10),
          _buildPaymentMethodItem(
            logoPath: 'assets/payment-gateway/bri.svg',
            name: 'Bank BRI',
            value: 'bri',
          ),
          const SizedBox(height: 10),
          _buildPaymentMethodItem(
            logoPath: 'assets/payment-gateway/bca.svg',
            name: 'Bank BCA',
            value: 'bca',
          ),
        ],
      ),
    );
  }

  /// Payment Method Item dengan radio button sesuai design
  Widget _buildPaymentMethodItem({
    required String logoPath,
    required String name,
    required String value,
  }) {
    final isSelected = _selectedPaymentMethod == value;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFBFBFB),
          border: Border.all(
            color: isSelected 
                ? AppColors.primaryPurple 
                : Colors.black.withValues(alpha: 0.15),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            // Logo container dengan SVG
            Container(
              width: 60,
              height: 40,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: SvgPicture.asset(
                logoPath,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 16),
            
            // Name
            Expanded(
              child: Text(
                name,
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            
            // Custom radio button sesuai design (circle outline)
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected 
                      ? AppColors.primaryPurple 
                      : const Color(0xFF909090),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  /// Bottom Button sesuai design
  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            text: 'Bayar dan Gabung Kursus',
            onPressed: _remainingTime.inSeconds > 0 ? _handlePayment : null,
          ),
        ),
      ),
    );
  }
}
