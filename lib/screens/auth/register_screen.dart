import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../styles/styles.dart';
import '../../widgets/universal/inputs/primary_text_field.dart';
import '../../widgets/universal/buttons/primary_button.dart';
import '../../providers/auth_provider.dart';
import '../error/error_screen.dart';

/// Screen register - Sign Up
/// Design reference: Sign up.svg
///
/// Fitur:
/// - Input email, password, dan confirm password menggunakan PrimaryTextField
/// - Link ke login screen
/// - Validasi password match
/// - Terintegrasi dengan AuthProvider untuk backend auth
/// - Network error handling dengan redirect ke ErrorScreen
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
  final _scrollController = ScrollController();

  // Keys for scroll into view
  final _nameKey = GlobalKey();
  final _emailKey = GlobalKey();
  final _passwordKey = GlobalKey();
  final _confirmPasswordKey = GlobalKey();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Scroll to make the target widget visible
  void _scrollToWidget(GlobalKey key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final keyContext = key.currentContext;
      if (keyContext != null) {
        Future.delayed(const Duration(milliseconds: 350), () {
          if (!mounted) return;
          // Re-check context after delay
          final ctx = key.currentContext;
          if (ctx != null) {
            Scrollable.ensureVisible(
              ctx,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
            );
          }
        });
      }
    });
  }

  /// Navigate to network error screen
  void _showNetworkError() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ErrorScreen.network(
          onRetry: () {
            Navigator.of(context).pop();
            _handleRegister();
          },
        ),
      ),
    );
  }

  /// Handle register dengan AuthProvider
  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      final navigator = GoRouter.of(context);
      final messenger = ScaffoldMessenger.of(context);

      final response = await authProvider.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (response.success) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              'Registrasi berhasil! Silakan cek email untuk verifikasi.',
            ),
            backgroundColor: AppColors.primaryPurple,
          ),
        );
        navigator.go('/login');
      } else if (response.isNetworkError) {
        // Show network error screen
        _showNetworkError();
      } else {
        messenger.showSnackBar(
          SnackBar(
            content: Text(response.message ?? 'Registrasi gagal'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              controller: _scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.only(
                left: AppDimensions.screenPadding,
                right: AppDimensions.screenPadding,
                top: AppDimensions.screenPadding,
                bottom: bottomPadding > 0
                    ? bottomPadding + 20
                    : AppDimensions.screenPadding,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      constraints.maxHeight - (AppDimensions.screenPadding * 2),
                ),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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

                        // Name Field with scroll handling
                        Container(
                          key: _nameKey,
                          child: PrimaryTextField(
                            labelText: 'Full Name',
                            hintText: 'Input your full name',
                            controller: _nameController,
                            keyboardType: TextInputType.name,
                            onFocusChange: (hasFocus) {
                              if (hasFocus) {
                                _scrollToWidget(_nameKey);
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Email Field with scroll handling
                        Container(
                          key: _emailKey,
                          child: PrimaryTextField(
                            labelText: 'Email Address',
                            hintText: 'Input your email',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            onFocusChange: (hasFocus) {
                              if (hasFocus) {
                                _scrollToWidget(_emailKey);
                              }
                            },
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
                        ),

                        const SizedBox(height: 20),

                        // Password Field with scroll handling
                        Container(
                          key: _passwordKey,
                          child: PrimaryTextField(
                            labelText: 'Password',
                            hintText: 'Create a password',
                            controller: _passwordController,
                            obscureText: true,
                            showPasswordToggle: true,
                            onFocusChange: (hasFocus) {
                              if (hasFocus) {
                                _scrollToWidget(_passwordKey);
                              }
                            },
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
                        ),

                        const SizedBox(height: 20),

                        // Confirm Password Field with scroll handling
                        Container(
                          key: _confirmPasswordKey,
                          child: PrimaryTextField(
                            labelText: 'Confirm Password',
                            hintText: 'Confirm your password',
                            controller: _confirmPasswordController,
                            obscureText: true,
                            showPasswordToggle: true,
                            onFocusChange: (hasFocus) {
                              if (hasFocus) {
                                _scrollToWidget(_confirmPasswordKey);
                              }
                            },
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
            );
          },
        ),
      ),
    );
  }
}
