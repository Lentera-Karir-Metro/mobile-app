import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../styles/styles.dart';
import '../../widgets/universal/inputs/primary_text_field.dart';
import '../../widgets/universal/buttons/primary_button.dart';

/// Screen input email untuk reset password
/// Design reference: Reset password (input email).svg
/// 
/// Fitur:
/// - Input email menggunakan PrimaryTextField
/// - Popup konfirmasi setelah submit (untuk saat ini tanpa backend)
/// - Back button ke login
class ResetPasswordInputEmailScreen extends StatefulWidget {
  const ResetPasswordInputEmailScreen({super.key});

  @override
  State<ResetPasswordInputEmailScreen> createState() =>
      _ResetPasswordInputEmailScreenState();
}

class _ResetPasswordInputEmailScreenState
    extends State<ResetPasswordInputEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  /// Handle send reset link - untuk saat ini tampilkan popup sukses
  void _handleSendResetLink() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 800));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Show success dialog
        _showSuccessDialog();
      }
    }
  }

  /// Show success dialog dengan konfirmasi link terkirim
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.primaryPurple,
                  size: 32,
                ),
              ),

              const SizedBox(height: 20),

              // Title
              Text(
                'Link Terkirim!',
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              // Message
              Text(
                'Tautan reset password telah dikirim ke email ${_emailController.text}',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // OK Button
              PrimaryButton(
                text: 'OK',
                onPressed: () {
                  // Close dialog dan back ke login
                  Navigator.of(context).pop();
                  context.go('/login');
                },
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.screenPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [

                  // Header - Reset Password
                  Text(
                    'Reset Password',
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Subtitle/Instruction
                  Text(
                    'Masukkan email Anda untuk menerima tautan reset password',
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Email Field
                  PrimaryTextField(
                    labelText: 'Email Address',
                    hintText: 'Input your email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      if (!value.contains('@')) {
                        return 'Email tidak valid';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 40),

                  // Send Button
                  Center(
                    child: PrimaryButton(
                      text: 'Kirim',
                      onPressed: _isLoading ? null : _handleSendResetLink,
                      width: 245,
                      isLoading: _isLoading,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Back to login link
                  Center(
                    child: GestureDetector(
                      onTap: () => context.go('/login'),
                      child: Text(
                        'Kembali ke Login',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.primaryPurple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}
