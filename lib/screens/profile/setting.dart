import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';
import 'package:lentera_karir/widgets/universal/inputs/primary_text_field.dart';
import 'package:lentera_karir/providers/auth_provider.dart';
import 'package:lentera_karir/screens/profile/change_password.dart';

/// Halaman Settings
/// Menampilkan pengaturan akun pengguna
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // Controllers untuk text fields
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final user = context.read<AuthProvider>().user;
      _usernameController = TextEditingController(text: user?.name ?? '');
      _emailController = TextEditingController(text: user?.email ?? '');
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
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
                    'Settings',
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
                        children: [
                          // Profile photo - using same style as home.dart
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                              final user = authProvider.user;
                              return CircleAvatar(
                                radius: 38.5,
                                backgroundColor: AppColors.divider,
                                backgroundImage: user?.avatar != null 
                                  ? NetworkImage(user!.avatar!)
                                  : null,
                                child: user?.avatar == null ? const Icon(
                                  Icons.person,
                                  color: AppColors.textSecondary,
                                  size: 48,
                                ) : null,
                              );
                            },
                          ),
                          const SizedBox(height: 24),

                          // Username field (read-only)
                          PrimaryTextField(
                            labelText: 'Username',
                            controller: _usernameController,
                            keyboardType: TextInputType.text,
                            readOnly: true,
                            enabled: false,
                          ),
                          const SizedBox(height: 16),

                          // Email Address field (read-only)
                          PrimaryTextField(
                            labelText: 'Email Address',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            readOnly: true,
                            enabled: false,
                          ),
                          const SizedBox(height: 24),

                          // Change Password button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ChangePasswordScreen(),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primaryPurple,
                                side: const BorderSide(color: AppColors.primaryPurple),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text(
                                'Ubah Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
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
