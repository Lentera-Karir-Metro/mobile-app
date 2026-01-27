import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../styles/styles.dart';
import '../../widgets/universal/inputs/primary_text_field.dart';
import '../../widgets/universal/buttons/primary_button.dart';
import '../../providers/auth_provider.dart';
import '../error/error_screen.dart';

/// Screen login - Sign In
/// Design reference: Sign in.svg
///
/// Fitur:
/// - Input email dan password menggunakan PrimaryTextField
/// - Link ke register screen
/// - Link ke reset password
/// - Terintegrasi dengan AuthProvider untuk backend auth
/// - Network error handling dengan redirect ke ErrorScreen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _scrollController = ScrollController();

  // Keys for scroll into view
  final _emailKey = GlobalKey();
  final _passwordKey = GlobalKey();
  final _buttonKey = GlobalKey();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
            _handleLogin();
          },
        ),
      ),
    );
  }

  /// Handle login dengan AuthProvider
  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      final navigator = GoRouter.of(context);

      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        navigator.go('/home');
      } else if (authProvider.isNetworkError) {
        // Show network error screen
        _showNetworkError();
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
                            hintText: 'Input your password',
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
                              return null;
                            },
                          ),
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
                          key: _buttonKey,
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
            );
          },
        ),
      ),
    );
  }
}
