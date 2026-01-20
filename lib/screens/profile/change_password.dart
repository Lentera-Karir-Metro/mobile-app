import 'package:flutter/material.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';
import 'package:lentera_karir/widgets/universal/inputs/primary_text_field.dart';
import 'package:lentera_karir/widgets/universal/buttons/primary_button.dart';
import 'package:get_it/get_it.dart';
import 'package:lentera_karir/data/api/api_service.dart';

/// Halaman Change Password
/// Menampilkan form untuk mengubah password
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    // Validate inputs
    if (_oldPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Semua field harus diisi';
      });
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Password baru dan konfirmasi password tidak sama';
      });
      return;
    }

    if (_newPasswordController.text.length < 6) {
      setState(() {
        _errorMessage = 'Password baru minimal 6 karakter';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiService = GetIt.instance<ApiService>();
      final response = await apiService.put(
        '/auth/change-password',
        body: {
          'currentPassword': _oldPasswordController.text,
          'newPassword': _newPasswordController.text,
        },
      );

      if (!mounted) return;

      if (response['success'] == true) {
        // Show success dialog
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.successGreen.withAlpha(26),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.successGreen,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Password Berhasil Diubah',
                  style: AppTextStyles.subtitle1.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Password Anda telah berhasil diperbarui.',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        );
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Gagal mengubah password';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
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
      body: SafeArea(
        child: Column(
          children: [
            // Header dengan back button dan title
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Row(
                children: [
                  // Back button
                  CustomBackButton(
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 16),
                  // Title
                  Text(
                    'Change Password',
                    style: AppTextStyles.heading3.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Card container untuk form
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.black.withAlpha(38),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Error message
                          if (_errorMessage != null) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.withAlpha(26),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red.withAlpha(77)),
                              ),
                              child: Text(
                                _errorMessage!,
                                style: AppTextStyles.body2.copyWith(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Password Lama field
                          PrimaryTextField(
                            labelText: 'Password Lama',
                            controller: _oldPasswordController,
                            obscureText: true,
                            showPasswordToggle: true,
                          ),
                          const SizedBox(height: 16),

                          // Password Baru field
                          PrimaryTextField(
                            labelText: 'Password Baru',
                            controller: _newPasswordController,
                            obscureText: true,
                            showPasswordToggle: true,
                          ),
                          const SizedBox(height: 16),

                          // Konfirmasi Password field
                          PrimaryTextField(
                            labelText: 'Konfirmasi Password',
                            controller: _confirmPasswordController,
                            obscureText: true,
                            showPasswordToggle: true,
                          ),
                          const SizedBox(height: 24),

                          // Submit button
                          SizedBox(
                            width: double.infinity,
                            child: PrimaryButton(
                              text: 'Ubah Password',
                              onPressed: _isLoading ? null : _changePassword,
                              isLoading: _isLoading,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
