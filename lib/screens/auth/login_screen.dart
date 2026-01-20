import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../styles/styles.dart';
import '../../widgets/universal/inputs/primary_text_field.dart';
import '../../widgets/universal/buttons/primary_button.dart';
import '../../providers/auth_provider.dart';

/// Screen login - Sign In
/// Design reference: Sign in.svg
/// 
/// Fitur:
/// - Input email dan password menggunakan PrimaryTextField
/// - Link ke register screen
/// - Link ke reset password
/// - Terintegrasi dengan AuthProvider untuk backend auth
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handle login dengan AuthProvider
  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      
      if (mounted) {
        if (success) {
          context.go('/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.errorMessage ?? 'Login gagal'),
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

                  // Header - Sign In
                  Text(
                    'Sign In',
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Subtitle - New user? Create an account
                  Row(
                    children: [
                      Text(
                        'New user? ',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/register'),
                        child: Text(
                          'Create an account',
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.primaryPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Password Field
                  PrimaryTextField(
                    labelText: 'Password',
                    hintText: 'Input your password',
                    controller: _passwordController,
                    obscureText: true,
                    showPasswordToggle: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password tidak boleh kosong';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  // Forgot Password Link
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => context.push('/reset-password-input'),
                      child: Text(
                        'Forgot Password?',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.primaryPurple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Login Button
                  Center(
                    child: PrimaryButton(
                      text: 'Sign In',
                      onPressed: isLoading ? null : _handleLogin,
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
