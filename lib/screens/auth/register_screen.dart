import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../styles/styles.dart';
import '../../widgets/universal/inputs/primary_text_field.dart';
import '../../widgets/universal/buttons/primary_button.dart';
import '../../providers/auth_provider.dart';

/// Screen register - Sign Up
/// Design reference: Sign up.svg
/// 
/// Fitur:
/// - Input email, password, dan confirm password menggunakan PrimaryTextField
/// - Link ke login screen
/// - Validasi password match
/// - Terintegrasi dengan AuthProvider untuk backend auth
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Handle register dengan AuthProvider
  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      
      final response = await authProvider.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      if (mounted) {
        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registrasi berhasil! Silakan cek email untuk verifikasi.'),
              backgroundColor: AppColors.primaryPurple,
            ),
          );
          context.go('/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? 'Registrasi gagal'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
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

                  // Header - Create Account
                  Text(
                    'Create Account',
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Subtitle - Already have an account? Sign In
                  Row(
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/login'),
                        child: Text(
                          'Sign In',
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.primaryPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Name Field
                  PrimaryTextField(
                    labelText: 'Full Name',
                    hintText: 'Input your full name',
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama tidak boleh kosong';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

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

                  const SizedBox(height: 20),

                  // Password Field
                  PrimaryTextField(
                    labelText: 'Password',
                    hintText: 'Create a password',
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

                  // Confirm Password Field
                  PrimaryTextField(
                    labelText: 'Confirm Password',
                    hintText: 'Confirm your password',
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

                  // Register Button
                  Center(
                    child: PrimaryButton(
                      text: 'Create Account',
                      onPressed: isLoading ? null : _handleRegister,
                      width: 245,
                      isLoading: isLoading,
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
