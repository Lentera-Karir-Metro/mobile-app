import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';

/// Screen untuk membuka dan menampilkan E-Book (PDF)
/// Menggunakan url_launcher untuk membuka PDF di browser/aplikasi PDF
class EbookViewerScreen extends StatefulWidget {
  final String title;
  final String url;

  const EbookViewerScreen({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<EbookViewerScreen> createState() => _EbookViewerScreenState();
}

class _EbookViewerScreenState extends State<EbookViewerScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Auto-open PDF when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openPdf();
    });
  }

  Future<void> _openPdf() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final Uri pdfUri = Uri.parse(widget.url);
      
      if (await canLaunchUrl(pdfUri)) {
        await launchUrl(
          pdfUri,
          mode: LaunchMode.externalApplication,
        );
        
        // Pop back after opening
        if (mounted) {
          Navigator.of(context).pop();
        }
      } else {
        setState(() {
          _errorMessage = 'Tidak dapat membuka PDF. URL tidak valid.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal membuka PDF: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        leading: CustomBackButton(
          backgroundColor: Colors.transparent,
          iconColor: AppColors.textPrimary,
        ),
        title: Text(
          widget.title,
          style: AppTextStyles.heading4.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading) ...[
                const CircularProgressIndicator(
                  color: AppColors.primaryPurple,
                ),
                const SizedBox(height: 24),
                Text(
                  'Membuka E-Book...',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ] else if (_errorMessage != null) ...[
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _openPdf,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Coba Lagi',
                    style: AppTextStyles.button.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ] else ...[
                // Default state - show open button
                Icon(
                  Icons.menu_book_outlined,
                  size: 80,
                  color: AppColors.primaryPurple,
                ),
                const SizedBox(height: 24),
                Text(
                  widget.title,
                  style: AppTextStyles.heading4.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _openPdf,
                  icon: const Icon(Icons.open_in_new, color: Colors.white),
                  label: Text(
                    'Buka E-Book',
                    style: AppTextStyles.button.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'E-Book akan dibuka di aplikasi PDF viewer',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
