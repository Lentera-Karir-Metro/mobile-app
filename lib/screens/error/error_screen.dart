import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/primary_button.dart';

/// Tipe error yang dapat ditampilkan
enum ErrorType {
  network,  // Tidak ada koneksi internet
  server,   // Server error (500, dll)
  notFound, // Data tidak ditemukan (404)
  unknown,  // Error tidak diketahui
}

/// Error Screen - ditampilkan ketika terjadi error jaringan atau server
/// Sesuai dengan design pada gambar error dengan cloud icon
class ErrorScreen extends StatelessWidget {
  /// Tipe error yang terjadi
  final ErrorType errorType;
  
  /// Callback ketika tombol Retry ditekan
  final VoidCallback? onRetry;
  
  /// Pesan error custom (opsional)
  final String? customMessage;

  const ErrorScreen({
    super.key,
    this.errorType = ErrorType.unknown,
    this.onRetry,
    this.customMessage,
  });

  /// Factory constructor untuk network error
  factory ErrorScreen.network({VoidCallback? onRetry}) {
    return ErrorScreen(
      errorType: ErrorType.network,
      onRetry: onRetry,
    );
  }

  /// Factory constructor untuk server error
  factory ErrorScreen.server({VoidCallback? onRetry, String? message}) {
    return ErrorScreen(
      errorType: ErrorType.server,
      onRetry: onRetry,
      customMessage: message,
    );
  }

  /// Mendapatkan pesan error berdasarkan tipe
  String _getErrorMessage() {
    if (customMessage != null) return customMessage!;
    
    switch (errorType) {
      case ErrorType.network:
        return 'Tidak ada koneksi internet. Periksa jaringan Anda dan coba lagi.';
      case ErrorType.server:
        return 'Server sedang mengalami gangguan. Silakan coba beberapa saat lagi.';
      case ErrorType.notFound:
        return 'Data yang Anda cari tidak ditemukan.';
      case ErrorType.unknown:
        return 'Terjadi kesalahan. Silakan coba lagi.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Error illustration (SVG cloud icon)
                SvgPicture.asset(
                  'assets/error/error.svg',
                  width: 220,
                  height: 180,
                ),
                
                const SizedBox(height: 40),
                
                // Title "Oops!"
                Text(
                  'Oops!',
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Error message
                Text(
                  _getErrorMessage(),
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 40),
                
                // Retry button
                if (onRetry != null)
                  SizedBox(
                    width: 200,
                    child: PrimaryButton(
                      text: 'Coba Lagi',
                      onPressed: onRetry!,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget error yang bisa digunakan di dalam screen lain (bukan full screen)
class ErrorWidget extends StatelessWidget {
  final ErrorType errorType;
  final VoidCallback? onRetry;
  final String? customMessage;

  const ErrorWidget({
    super.key,
    this.errorType = ErrorType.unknown,
    this.onRetry,
    this.customMessage,
  });

  String _getErrorMessage() {
    if (customMessage != null) return customMessage!;
    
    switch (errorType) {
      case ErrorType.network:
        return 'Tidak ada koneksi internet';
      case ErrorType.server:
        return 'Server sedang gangguan';
      case ErrorType.notFound:
        return 'Data tidak ditemukan';
      case ErrorType.unknown:
        return 'Terjadi kesalahan';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/error/error.svg',
              width: 150,
              height: 120,
            ),
            const SizedBox(height: 24),
            Text(
              'Oops!',
              style: AppTextStyles.heading4.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getErrorMessage(),
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: 150,
                child: PrimaryButton(
                  text: 'Coba Lagi',
                  onPressed: onRetry!,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
