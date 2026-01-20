import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/providers/payment_provider.dart';

/// Screen untuk menampilkan Midtrans Payment WebView
/// Membuka redirect_url dari backend dan listen untuk callback
class MidtransWebViewScreen extends StatefulWidget {
  final String courseId;
  final String orderId;
  final String redirectUrl;
  final double totalAmount;

  const MidtransWebViewScreen({
    super.key,
    required this.courseId,
    required this.orderId,
    required this.redirectUrl,
    required this.totalAmount,
  });

  @override
  State<MidtransWebViewScreen> createState() => _MidtransWebViewScreenState();
}

class _MidtransWebViewScreenState extends State<MidtransWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
              _errorMessage = 'Gagal memuat halaman pembayaran';
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url.toLowerCase();
            
            // Detect callback URLs from Midtrans
            // Success URL patterns
            if (url.contains('transaction_status=settlement') ||
                url.contains('transaction_status=capture') ||
                url.contains('status_code=200')) {
              _handlePaymentSuccess();
              return NavigationDecision.prevent;
            }
            
            // Pending URL patterns
            if (url.contains('transaction_status=pending')) {
              _handlePaymentPending();
              return NavigationDecision.prevent;
            }
            
            // Failed/Expired URL patterns
            if (url.contains('transaction_status=deny') ||
                url.contains('transaction_status=cancel') ||
                url.contains('transaction_status=expire') ||
                url.contains('transaction_status=failure')) {
              _handlePaymentFailed();
              return NavigationDecision.prevent;
            }
            
            // Handle deep links (gopay://, dana://, etc.)
            if (url.startsWith('gojek://') ||
                url.startsWith('gopay://') ||
                url.startsWith('dana://') ||
                url.startsWith('shopeeid://') ||
                url.startsWith('ovo://')) {
              // Let the system handle deep links
              return NavigationDecision.navigate;
            }
            
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.redirectUrl));
  }

  void _handlePaymentSuccess() async {
    // Sync payment status with backend
    final paymentProvider = context.read<PaymentProvider>();
    await paymentProvider.checkPaymentStatus(widget.orderId);
    
    if (mounted) {
      // Navigate to success screen
      context.go('/payment/success', extra: {
        'orderId': widget.orderId,
        'courseId': widget.courseId,
      });
    }
  }

  void _handlePaymentPending() async {
    // Sync payment status with backend
    final paymentProvider = context.read<PaymentProvider>();
    await paymentProvider.checkPaymentStatus(widget.orderId);
    
    if (mounted) {
      // Navigate to pending screen
      context.go('/payment/pending', extra: {
        'orderId': widget.orderId,
        'courseId': widget.courseId,
      });
    }
  }

  void _handlePaymentFailed() async {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pembayaran gagal atau dibatalkan'),
          backgroundColor: Colors.red,
        ),
      );
      context.pop(); // Go back to previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryPurple,
        title: const Text(
          'Pembayaran',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => _showCloseConfirmation(),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          if (_errorMessage != null)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: AppTextStyles.body1.copyWith(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _errorMessage = null;
                        _isLoading = true;
                      });
                      _controller.loadRequest(Uri.parse(widget.redirectUrl));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                    ),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            )
          else
            WebViewWidget(controller: _controller),
          
          // Loading indicator
          if (_isLoading)
            Container(
              color: Colors.white.withValues(alpha: 0.8),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Memuat halaman pembayaran...'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showCloseConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Batalkan Pembayaran?'),
        content: const Text(
          'Apakah Anda yakin ingin membatalkan pembayaran? '
          'Transaksi akan tetap pending dan bisa dilanjutkan nanti.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
  }
}
