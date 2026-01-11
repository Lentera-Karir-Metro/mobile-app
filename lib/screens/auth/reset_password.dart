import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../styles/styles.dart';
import '../../widgets/universal/inputs/primary_text_field.dart';
import '../../widgets/universal/buttons/primary_button.dart';

/// Screen ganti password baru (setelah klik link dari email)
/// Design reference: Reset password (ganti password).svg
/// 
/// Fitur:
/// - Input password baru dan konfirmasi password
/// - Validasi password match
/// - Success dialog dan navigate ke login
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Handle reset password - untuk saat ini tampilkan popup sukses
  void _handleResetPassword() async {
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

  /// Show success dialog password berhasil diubah
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
                'Password Berhasil Diubah!',
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Message
              Text(
                'Password Anda telah berhasil diperbarui. Silakan login dengan password baru Anda.',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // OK Button
              PrimaryButton(
                text: 'Login Sekarang',
                onPressed: () {
                  // Close dialog dan ke login
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
                    'Masukkan password baru Anda',
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Password Baru Field
                  PrimaryTextField(
                    labelText: 'Password Baru',
                    hintText: 'Masukkan password baru',
                    controller: _passwordController,
                    obscureText: true,
                    showPasswordToggle: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password tidak boleh kosong';
                      }
                      if (value.length < 6) {
                        return 'Password minimal 6 karakter';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Konfirmasi Password Field
                  PrimaryTextField(
                    labelText: 'Konfirmasi Password',
                    hintText: 'Konfirmasi password yang telah dimasukkan',
                    controller: _confirmPasswordController,
                    obscureText: true,
                    showPasswordToggle: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Konfirmasi password tidak boleh kosong';
                      }
                      if (value != _passwordController.text) {
                        return 'Password tidak cocok';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 40),

                  // Submit Button
                  Center(
                    child: PrimaryButton(
                      text: 'Kirim',
                      onPressed: _isLoading ? null : _handleResetPassword,
                      width: 245,
                      isLoading: _isLoading,
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
