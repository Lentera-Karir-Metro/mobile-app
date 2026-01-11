import 'package:flutter/material.dart';
import 'package:lentera_karir/styles/styles.dart';

/// Enum untuk status sertifikat
enum SertifikatStatus {
  /// Belum bisa klaim - kursus belum selesai
  notReady,

  /// Bisa klaim - kursus sudah selesai
  canClaim,

  /// Sedang diproses - menunggu konfirmasi
  inProgress,
}

/// Widget untuk menampilkan status sertifikat
/// 
/// Terdapat 3 status:
/// - [SertifikatStatus.notReady]: Background merah, "Selesaikan kursus"
/// - [SertifikatStatus.canClaim]: Background hijau, "Unduh sertifikmu"
/// - [SertifikatStatus.inProgress]: Background abu-abu, "Tunggu konfirmasi"
class SertifStatus extends StatelessWidget {
  final SertifikatStatus status;
  final VoidCallback? onTap;

  const SertifStatus({
    super.key,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Icon sertifikat
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getIconBackgroundColor(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.workspace_premium_rounded,
                color: _getIconColor(),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getTitle(),
                    style: AppTextStyles.body1.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _getTextColor(),
                    ),
                  ),
                  // Hanya tampilkan warning/subtitle untuk status notReady (merah)
                  if (status == SertifikatStatus.notReady) ...[
                    const SizedBox(height: 4),
                    Text(
                      _getSubtitle(),
                      style: AppTextStyles.caption.copyWith(
                        color: _getSubtitleColor(),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Arrow icon for canClaim status
            if (status == SertifikatStatus.canClaim)
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: _getIconColor(),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (status) {
      case SertifikatStatus.notReady:
        return const Color(0xFFFF383C).withAlpha(26);
      case SertifikatStatus.canClaim:
        return const Color(0xFF34C759).withAlpha(26);
      case SertifikatStatus.inProgress:
        return const Color(0xFF747474).withAlpha(26);
    }
  }

  Color _getIconBackgroundColor() {
    switch (status) {
      case SertifikatStatus.notReady:
        return const Color(0xFFFF383C).withAlpha(38);
      case SertifikatStatus.canClaim:
        return const Color(0xFF34C759).withAlpha(38);
      case SertifikatStatus.inProgress:
        return const Color(0xFF747474).withAlpha(38);
    }
  }

  Color _getIconColor() {
    switch (status) {
      case SertifikatStatus.notReady:
        return const Color(0xFFFF383C);
      case SertifikatStatus.canClaim:
        return const Color(0xFF34C759);
      case SertifikatStatus.inProgress:
        return const Color(0xFF747474);
    }
  }

  Color _getTextColor() {
    switch (status) {
      case SertifikatStatus.notReady:
        return const Color(0xFFFF383C);
      case SertifikatStatus.canClaim:
        return const Color(0xFF34C759);
      case SertifikatStatus.inProgress:
        return const Color(0xFF747474);
    }
  }

  Color _getSubtitleColor() {
    switch (status) {
      case SertifikatStatus.notReady:
        return const Color(0xFFFF383C).withAlpha(179);
      case SertifikatStatus.canClaim:
        return const Color(0xFF34C759).withAlpha(179);
      case SertifikatStatus.inProgress:
        return const Color(0xFF747474).withAlpha(179);
    }
  }

  String _getTitle() {
    switch (status) {
      case SertifikatStatus.notReady:
        return 'Klaim sertifikat';
      case SertifikatStatus.canClaim:
        return 'Klaim sertifikat';
      case SertifikatStatus.inProgress:
        return 'Sertifikat sedang diproses';
    }
  }

  String _getSubtitle() {
    switch (status) {
      case SertifikatStatus.notReady:
        return 'Selesaikan kursus terlebih dahulu';
      case SertifikatStatus.canClaim:
        return 'Unduh sertifikmu sekarang';
      case SertifikatStatus.inProgress:
        return 'Tunggu konfirmasi dari admin';
    }
  }
}
